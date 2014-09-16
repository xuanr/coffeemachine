//
//  NetWorkState.m
//  Created by MK on 2/20/12.
//

#import "NetworkDetector.h"
#import "Reachability.h"
#import <CFNetwork/CFNetwork.h>
#import <netinet/in.h>
#import <sys/errno.h>
#import <arpa/inet.h>
#import <SystemConfiguration/SCNetwork.h>

#define TIMER_INTERVAL 20.0f
#define NETWORK_TEST_HOST @"www.baidu.com"

static dispatch_queue_t serial_queue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("network_detector_queue_serial", DISPATCH_QUEUE_SERIAL);
    });

    return queue;
}

static dispatch_queue_t cuncurrent_queue() {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0UL);

    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("network_detector_queue_serial", DISPATCH_QUEUE_CONCURRENT);
    });

    return queue;
}

NS_INLINE void showReachState(Reachability* reach) {
#if DEBUG
    NSLog(@"reachability state %d, connetionRequired %d", reach.currentReachabilityStatus, reach.connectionRequired);
#endif
}


NSString *NetworkStateDetectorStateDidChanged =  @"NetworkStateDetectorStateDidChanged";

@interface NetworkDetector()

@property (assign, nonatomic) NetworkDetectorState state;

@property (strong, nonatomic) Reachability *netReachability;
@property (strong, nonatomic) Reachability *nameReachability;

@property (copy, nonatomic) NSString *host;
@property (weak, nonatomic) NSTimer *timer;

@end

@implementation NetworkDetector

+ (id)sharedDetector
{
    static id instance = nil;
    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        instance = [[self alloc] initWithHost:NETWORK_TEST_HOST];
    });

    return instance;
}

+ (NSArray *)getIpAddress:(NSString *)hostName error:(NSError **)error
{
    NSArray *ipAddress = nil;
    CFHostRef hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)hostName);
    if (hostRef != NULL) {
        CFStreamError streamError;
        if (CFHostStartInfoResolution(hostRef, kCFHostAddresses, &streamError)) {
            Boolean hasBeenResolved = false;
            CFArrayRef addresses = CFHostGetAddressing(hostRef, &hasBeenResolved);
            if (hasBeenResolved && addresses != NULL) {
                NSUInteger count = CFArrayGetCount(addresses);
                ipAddress = [NSMutableArray arrayWithCapacity:count];
                for (NSUInteger idx = 0; idx < count; ++idx) {
                    CFDataRef data = CFArrayGetValueAtIndex(addresses, idx);
                    struct sockaddr_in *remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(data);
                    char *str = inet_ntoa(remoteAddr->sin_addr);
                    [(NSMutableArray *)ipAddress addObject:[NSString stringWithCString:str encoding:NSASCIIStringEncoding]];
                }
            }
        } else if (error != NULL){
            *error = [NSError errorWithDomain:@(streamError.domain).description
                                         code:streamError.error
                                     userInfo:nil];
        }
        CFRelease(hostRef);
    }
    return ipAddress;
}

+ (void)getIpAddress:(NSString *)hostName block:(void (^)(NSArray *address, NSError *error))block
{
    dispatch_async(cuncurrent_queue(), ^() {
        if (block != nil) {
            NSError *error = nil;
            NSArray *array = [self getIpAddress:hostName error:&error];
            block(array, error);
        }
    });
}


#if 0
+ (BOOL)isReachable:(NSString *)hostName error:(NSError **)error
{
    BOOL reachable = false;
    CFHostRef hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)hostName);
    if (hostRef) {
        CFStreamError streamError;
        Boolean hasBeenResolved = false;
        if (CFHostStartInfoResolution(hostRef, kCFHostReachability, &streamError)) {
            CFDataRef data = CFHostGetReachability(hostRef, &hasBeenResolved);
            if (hasBeenResolved) {
                SCNetworkConnectionFlags flags = *(SCNetworkConnectionFlags *)CFDataGetBytePtr(data);
                reachable = (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
            }
        } else if (error != NULL){
            *error = [NSError errorWithDomain:@(streamError.domain).description
                                         code:streamError.error
                                     userInfo:nil];
        }
        CFRelease(hostRef);
    }
    return reachable;
}

#endif

#pragma mark - Instance

- (id)initWithHost:(NSString *)host
{
    self = [super init];

    if (self != nil) {
        _host = [host copy];

        _netReachability = [Reachability reachabilityForInternetConnection];
        _nameReachability = [Reachability reachabilityWithHostName:_host];

        _state = (NetworkDetectorState)[_netReachability currentReachabilityStatus];

        [self checkReachablity:_netReachability];
        [self checkReachablity:_nameReachability];

        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        SEL sel = @selector(reachablitydidChanged:);
        [center addObserver:self
                   selector:sel
                       name:kReachabilityChangedNotification
                     object:_netReachability];

        [center addObserver:self
                   selector:sel
                       name:kReachabilityChangedNotification
                     object:_nameReachability];

        showReachState(_netReachability);
        showReachState(_nameReachability);

        [_netReachability startNotifier];
        [_nameReachability startNotifier];

        showReachState(_netReachability);
        showReachState(_nameReachability);
    }

    return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer performSelectorOnMainThread:@selector(invalidate) withObject:nil waitUntilDone:false];
    [_netReachability stopNotifier];
    [_nameReachability stopNotifier];
}

- (void)setState:(NetworkDetectorState)state
{
    if (_state != state) {
        NSString *key = @"state";
        [self willChangeValueForKey:key];
        _state = state;
        [self didChangeValueForKey:key];

        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkStateDetectorStateDidChanged
                                                            object:self];
    }
}

#pragma mark - Resolve Host Name
- (void)startIpResolveTimer:(float)interval
{
    [self stopIpResolveTimer];

    NSTimer *timer = [NSTimer timerWithTimeInterval:interval
                                             target:self
                                           selector:@selector(resolveHost:)
                                           userInfo:nil
                                            repeats:false];

    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    self.timer = timer;
}

- (void)stopIpResolveTimer
{
    [_timer performSelectorOnMainThread:@selector(invalidate) withObject:nil waitUntilDone:false];
    self.timer = nil;
}

- (void)resolveHost:(NSTimer *)aTimer
{
#if DEBUG
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"resolve start : %@", _host);
    });
#endif

    __weak __typeof(&*self)weakObj = self;
    dispatch_async(serial_queue(), ^() {
        if (weakObj.timer != aTimer) {
            return;
        }

        NSError *error = nil;
        NSArray *array = [[weakObj class] getIpAddress:_host error:&error];

        BOOL isOK = error == nil && array.count > 0;
        NetworkDetectorState state = NetworkDetectorStateNotReachable;

        if (isOK) {
            [weakObj stopIpResolveTimer];

            NetworkStatus ar_state = [weakObj.netReachability currentReachabilityStatus];
            state = (NetworkDetectorState)ar_state;
        } else {
            [weakObj startIpResolveTimer:TIMER_INTERVAL];
        }

        weakObj.state = state;
#if DEBUG
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isOK) {
                NSLog(@"resolve done : %@", array);
            } else {
                NSLog(@"resolve fail %@", error);
            }
        });
#endif
    });
}

#pragma mark - Network State
/**
 * @brief if the net reachability is down, then the network must be down
 *        if the net reachability is up, then resolving the dns of host to determine the network status
 *        if the name reachability is up, then the network must be up
 */
- (void)checkReachablity:(Reachability *)reach
{
    __weak __typeof(&*self)weakObj = self;
    dispatch_async(serial_queue(), ^{
        NetworkStatus state = reach.currentReachabilityStatus;
        BOOL isHostName = reach == _nameReachability;
        if (state != NotReachable) { // if network is ok
            if (isHostName) {                              // name reachability
                [weakObj stopIpResolveTimer];
                weakObj.state = (NetworkDetectorState)state;
            } else {
                [weakObj startIpResolveTimer:1.5f];    // don't start immediately, name reachability may cancel the resolving
            }
        } else if (!isHostName) {
            [weakObj stopIpResolveTimer];
            weakObj.state = NetworkDetectorStateNotReachable;
        }
    });
}

- (void)reachablitydidChanged:(NSNotification *)note
{
    [self checkReachablity:note.object];
}

- (BOOL)isReachable
{
    return _state == NetworkDetectorStateViaWiFi || _state == NetworkDetectorStateViaWWAN;
}

- (BOOL)isReachableVia3G
{
    return _state == NetworkDetectorStateViaWWAN;
}

@end
