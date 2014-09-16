//
//  HttpRequest.h
//  coffeeMachine
//
//  Created by Beifei on 5/21/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PAGE_ENTRYS 20

typedef enum
{
    Error_Code_DataMissing = 401,
    Error_Code_DataIllegal,
    Error_Code_ChaptchaFail,
    Error_Code_ServerError = 500,
    Error_Code_UserConflict = 601,
    Error_Code_UserNotExist,
    Error_Code_LoginError,
    Error_Code_LoginOuttime,
    Error_Code_BalanceExceed,
    Error_Code_PasswordError,
    Error_Code_MailNotBind,
    Error_Code_PhotoNotExist,
    Error_Code_GoodsExist = 701,
    Error_Code_GoodsNotExist,
    Error_Code_UserIndentDismatch,
    Error_Code_LackOfBalance,
    Error_Code_MultiPayment
} Error_Code;

typedef enum
{
    VerifyCodeType_Register=1,
    VerifyCodeType_BindMail,
    VerifyCodeType_ResetPassword
} VerifyCodeType;

typedef enum
{
    AvatarSize_Origin,
    AvatarSize_Middle,
    AvatarSize_Small
} AvatarSize;

typedef enum
{
    PayType_Balance = 1,
    PayType_Alipay
} PayType;

typedef enum
{
    OrderSource_Other,
    OrderSource_Cart
}OrderSource;

typedef enum
{
    OrderType_Untaken,
    OrderType_Taken,
    OrderType_Refund,
    OrderType_All,
}OrderType;

typedef enum
{
    Culture_Back,
    Culture_Forward
} CultureListType;

@interface HttpRequest : NSObject

+ (NSOperation *)coffeePictureWithTimeStamp:(double)timeInterval completionWithSuccess:(void(^)(NSDictionary *list))completion failure:(void(^)(int errorCode))failure;

+ (NSOperation *)registerRequestWithUser:(NSString *)user password:(NSString *)password verifyCode:(NSString *)verifyCode completionWithSuccess:(void(^)(NSString *token,NSString *userId))completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)verifyCodeWithUser:(NSString *)user type:(VerifyCodeType)type completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)verifyCodeWithUser:(NSString *)user email:(NSString *)email completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)loginWithUser:(NSString *)user password:(NSString *)password completionWithSuccess:(void(^)(NSString *token, NSString *userId))completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)logoutWithUser:(NSString *)user token:(NSString *)token completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)userInfo:(NSString *)user token:(NSString *)token completionWithSuccess:(void(^)(NSArray *array))completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)modifyUserInfo:(NSDictionary *)dict user:(NSString *)user token:(NSString *)token completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure;

+ (NSOperation *)rechargeWithUser:(NSString *)user token:(NSString *)token money:(NSString *)money completionWithSuccess:(void(^)(NSString *response))completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)remainWithUser:(NSString *)user token:(NSString *)token completionWithSuccess:(void(^)(NSNumber *response))completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)tradeWithUser:(NSString *)user token:(NSString *)token page:(NSInteger)page completionWithSuccess:(void(^)(NSArray *array))completion failure:(void(^)(int errorCode))failure;

+ (NSOperation *)modifyAvatarWithUser:(NSString *)user token:(NSString *)token avatar:(NSData *)avatarData completionWithSuccess:(void(^)(NSString *response))completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)avatarWithUser:(NSString *)user token:(NSString *)token offset:(NSInteger)offset size:(AvatarSize)size completionWithSuccess:(void(^)(NSString *))completion failure:(void(^)(int errorCode))failure;

+ (NSOperation *)MailRestPassword:(NSString *)user completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)ResetUserPassword:(NSString *)user password:(NSString *)password verifyCode:(NSString *)verifyCode completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure;

+ (NSOperation *)productListAtPage:(NSInteger)page entrys:(NSInteger)entrys completionWithSuccess:(void(^)(NSArray *arr))completion failure:(void(^)(int errorCode))failure;

//order
+ (NSOperation *)submitOrderWithUser:(NSString *)user token:(NSString *)token content:(NSString *)content dosing:(NSString *)dosing source:(OrderSource)source completionWithSuccess:(void(^)(NSArray *arr, NSArray *infoArr,NSString *orderId))completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)payOrderWithUser:(NSString *)user token:(NSString *)token indent:(NSString *)indent method:(PayType)method useBalance:(BOOL)use completionWithSuccess:(void(^)(NSString *result))completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)orderListWithUser:(NSString *)user token:(NSString *)token page:(NSInteger)page type:(OrderType)type completionWithSuccess:(void(^)(NSArray *array))completion failure:(void(^)(int errorCode))failure;

+ (NSOperation *)dossingCompletionWithSuccess:(void(^)(NSArray *dosingArr))completion failure:(void(^)(int errorCode))failure;

//favorite
+ (NSOperation *)favListWithUser:(NSString *)user token:(NSString *)token completionWithSuccess:(void(^)(NSArray *array))completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)addFavWithUser:(NSString *)user token:(NSString *)token coffee:(NSString *)coffeeId dosing:(NSString*)dosing completionWithSuccess:(void(^)(NSDictionary *dict))completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)removeFavWithUser:(NSString *)user token:(NSString *)token coffee:(NSString *)coffeeId dosing:(NSString*)dosing completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure;

//cart
+ (NSOperation *)addToCartWithUser:(NSString *)user token:(NSString *)token coffee:(NSString *)coffeeId dosing:(NSString*)dosing num:(NSInteger)num completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)removeFromCartWithUser:(NSString *)user token:(NSString *)token coffee:(NSString *)content completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)modifyCartWithUser:(NSString *)user token:(NSString *)token coffee:(NSString *)content coffeeNum:(NSString *)coffeeNum completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)cartListWithUser:(NSString *)user token:(NSString *)token page:(NSInteger)page  completionWithSuccess:(void(^)(NSArray *arr))completion failure:(void(^)(int errorCode))failure;

+ (NSOperation *)takeProductWithUser:(NSString *)user coffeeid:(NSString*)coffeeid completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)returnProductWithUser:(NSString *)user token:(NSString *)token coffeeid:(NSString*)coffeeid completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure;

//comments
+ (NSOperation *)commentListWithCoffeeId:(NSString *)coffeeId page:(NSInteger)page completionWithSuccess:(void(^)(NSArray *array))completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)commentWithUser:(NSString *)user token:(NSString *)token coffeeId:(NSString *)coffeeId comment:(NSString *)comment pic:(NSString*)commentPic longitude:(float)longitude latitude:(float)latitude completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)uploadCommentPhotoOPWithUser:(NSString *)user token:(NSString *)token coffeeId:(NSString *)coffeeId photo:(NSData *)photo completionWithSuccess:(void(^)(NSString *pic))completion failure:(void(^)(int errorCode))failure;

//culture
+ (NSOperation *)cultureListWithLastId:(NSString *)lastid type:(CultureListType)type completionWithSuccess:(void(^)(NSArray *arr))completion failure:(void(^)(int errorCode))failure;
+ (NSOperation *)coffeeMachineListWithTimestamp:(NSString *)timeStamp CompletionWithSuccess:(void(^)(NSArray *dict,NSString *timeStamp))completion failure:(void(^)(int errorCode))failure;

+ (NSOperation *)versionCompletionWithSuccess:(void(^)(NSString *version, NSString *updateUrl))completion failure:(void(^)(int errorCode))failure;

+ (NSString *)errorMsg:(NSInteger)errorCode;

//setting
+(NSOperation *)UpdateUserPassword:(NSString*)user OldPassword:(NSString *)oldPassword NewPassword:(NSString*)newPassword Token:(NSString*)token completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure;
@end
