//
//  UserInfo.m
//  coffeeMachine
//
//  Created by Beifei on 5/29/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "UserInfo.h"
#import "UIImage+Utilities.h"

@interface UserInfo()

@property (strong, nonatomic) NSOperation *favOperation;

@end

@implementation UserInfo

+ (UserInfo *)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        _isLogin = NO;
        
        [self restoreLoginStatus];
    }
    return self;
}

- (void)logout
{
    _isLogin = NO;
    _userId = nil;
    _token = nil;
    
    self.favArr = nil;
    self.userAvatar = nil;
    self.middleAvatar = nil;
    self.smallAvatar = nil;
    
    [self saveLoginStatus];
}

- (void)restoreLoginStatus
{
    _isLogin = [[[NSUserDefaults standardUserDefaults]objectForKey:@"loginStatus"]boolValue];
    
    if (_isLogin) {
        _userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
        _token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        
        [self fetchFavList];
    }
}

- (void)saveLoginStatus
{
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:_isLogin] forKey:@"loginStatus"];
    if (_isLogin) {
        [[NSUserDefaults standardUserDefaults]setObject:_userId forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults]setObject:_token forKey:@"token"];
    }
    
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)loginWithUserId:(NSString *)userId token:(NSString *)token
{
    _isLogin = YES;
    _userId = userId;
    _token = token;
    
    self.favArr = [NSMutableArray array];
    [self fetchFavList];
    
    [self saveLoginStatus];
}

- (void)registerWithUserId:(NSString *)userId token:(NSString *)token
{
    _isLogin = YES;
    _userId = userId;
    _token = token;
    
    [self saveLoginStatus];
}

- (void)fetchFavList
{
    if (!_isLogin) {
        return;
    }
    if (self.favOperation) {
        return;
    }
    
    __weak UserInfo *obj = self;
    self.favOperation = [HttpRequest favListWithUser:_userId token:_token completionWithSuccess:^(NSArray *array) {
        obj.favOperation = nil;
        obj.favArr = [NSMutableArray arrayWithArray:array];
    } failure:^(int errorCode) {
        obj.favOperation = nil;
    }];
}

- (void)removeFav:(NSDictionary *)fav
{
    if([self checkHasFav:fav]) {
        [self.favArr removeObject:fav];
    }
}

- (void)addFav:(NSDictionary *)fav
{
    if(![self checkHasFav:fav]) {
        [self.favArr addObject:fav];
    }
}

- (BOOL)checkHasFavWithCoffeeId:(NSString *)favId dosing:(NSString *)favDosing
{

    for (NSDictionary *dict in self.favArr) {
        NSString *coffeeid = [dict objectForKey:@"coffeeid"];
        NSString *dosing = [dict objectForKey:@"dosing"];
        
        if ([coffeeid isEqualToString:favId]&&[favDosing isEqualToString:dosing]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)checkHasFav:(NSDictionary *)fav
{
    NSString *favId = [fav objectForKey:@"coffeeid"];
    NSString *favDosing = [fav objectForKey:@"dosing"];
    
    return [self checkHasFavWithCoffeeId:favId dosing:favDosing];
}

- (void)updateUserInfoType:(UserInfo_Type)type value:(NSString *)value
{
    self.userInfo[type]=value;
}

- (void)setUserAvatar:(UIImage *)userAvatar
{
    _userAvatar = userAvatar;
    _smallAvatar = [userAvatar scaleToSize:CGSizeMake(57, 57)];
    _middleAvatar = [userAvatar scaleToSize:CGSizeMake(100, 100)];
}

- (void)setMiddleAvatar:(UIImage *)middleAvatar
{
    _middleAvatar = middleAvatar;
    _smallAvatar = [_middleAvatar scaleToSize:CGSizeMake(57, 57)];
}

- (void)setSmallAvatar:(UIImage *)smallAvatar
{
    _smallAvatar = smallAvatar;
}

@end
