//
//  NetWorkState.h
//
//  Created by MK on 2/20/12.
//

#import <Foundation/Foundation.h>

extern NSString *NetworkStateDetectorStateDidChanged;

typedef NS_ENUM(char, NetworkDetectorState) {
    //    NetworkDetectorStateUnknown = -1,
    NetworkDetectorStateNotReachable,
    NetworkDetectorStateViaWiFi,
    NetworkDetectorStateViaWWAN
};

@interface NetworkDetector : NSObject

//KVO
@property (nonatomic, assign, readonly) NetworkDetectorState state;

+ (NetworkDetector *)sharedDetector;

+ (NSArray *)getIpAddress:(NSString *)hostName error:(NSError **)error;

+ (void)getIpAddress:(NSString *)hostName block:(void (^)(NSArray *address, NSError *error))block;

/**
 * @brief Network is OK
 */
- (BOOL)isReachable;

/**
 * @brief Network is using wwlan
 */
- (BOOL)isReachableVia3G;

@end