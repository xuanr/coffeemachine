//
//  UserInfo.h
//  coffeeMachine
//
//  Created by Beifei on 5/29/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, strong) NSString *mobile;
@property (readonly, strong) NSString *userId;
@property (readonly, strong) NSString *token;
@property (nonatomic, strong) NSMutableArray *userInfo;
@property (nonatomic, strong) NSMutableArray *favArr;

@property (nonatomic, strong) UIImage *userAvatar;
@property (nonatomic, strong) UIImage *smallAvatar;
@property (nonatomic, strong) UIImage *middleAvatar;

+ (UserInfo *)sharedInstance;

- (void)logout;
- (void)loginWithUserId:(NSString *)userId token:(NSString *)token;
- (void)updateUserInfoType:(UserInfo_Type)type value:(NSString *)value;
- (void)registerWithUserId:(NSString *)userId token:(NSString *)token;

- (void)removeFav:(NSDictionary *)fav;
- (void)addFav:(NSDictionary *)fav;
- (BOOL)checkHasFavWithCoffeeId:(NSString *)coffeeId dosing:(NSString *)dosing;

@end
