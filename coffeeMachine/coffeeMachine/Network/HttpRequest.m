//
//  HttpRequest.m
//  coffeeMachine
//
//  Created by Beifei on 5/21/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"

#ifdef TestServer
#define Server @"http://jxvenus.3322.org:8081/coffeemachine_dev/servlet/"
#else
#define Server @"http://jxvenus.3322.org:8081/coffeemachine/servlet/"
#endif
//#define Server @"http://10.240.154.218:8080/coffeemachine/servlet/"

@implementation HttpRequest

+ (NSString *)errorMsg:(NSInteger)errorCode
{
    switch (errorCode) {
        case Error_Code_DataMissing:
            return NSLocalizedString(@"DATA_MISSING", nil);
        case Error_Code_DataIllegal:
            return NSLocalizedString(@"DATA_ILLEGAL", nil);
        case Error_Code_ChaptchaFail:
            return NSLocalizedString(@"CHAPTCHA_FAIL", nil);
        case Error_Code_ServerError:
            return NSLocalizedString(@"SERVER_ERROR", nil);
        case Error_Code_UserConflict:
            return NSLocalizedString(@"USER_EXIST", nil);
        case Error_Code_UserNotExist:
            return NSLocalizedString(@"USER_NOT_EXIST", nil);
        case Error_Code_LoginError:
            return NSLocalizedString(@"LOGIN_FAIL", nil);
        case Error_Code_LoginOuttime:
            return NSLocalizedString(@"LOGIN_OUTIME", nil);
        case Error_Code_BalanceExceed:
            return NSLocalizedString(@"BALANCE_EXCEED", nil);
        case Error_Code_PasswordError:
            return NSLocalizedString(@"PASSWORD_ERROR", nil);
        case Error_Code_PhotoNotExist:
            return NSLocalizedString(@"PHOTO_NOT_EXIST", nil);
        case Error_Code_GoodsExist:
            return NSLocalizedString(@"GOOD_EXIST", nil);
        case Error_Code_GoodsNotExist:
            return NSLocalizedString(@"GOOD_NOT_EXIST", nil);
        case Error_Code_UserIndentDismatch:
            return NSLocalizedString(@"USER_ORDER_DISMATCH", nil);
        case Error_Code_LackOfBalance:
            return NSLocalizedString(@"LACK_OF_BALANCE", nil);
        case Error_Code_MultiPayment:
            return NSLocalizedString(@"MULTI_PAYMENT", nil);
        default:
            return NSLocalizedString(@"REQUEST_ERROR", nil);
    }
}

//Get Request
+ (NSOperation *)httpGetRequest:(NSString*)url completionWithSuccess:(void(^)(NSDictionary *responseDict, NSData *data))completion failure:(void(^)(int errorCode))failure
{
    NSURLRequest *request =  [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        if (operation.responseString == nil) {
            if (operation.responseData!=nil) {
                completion(nil,operation.responseData);
            }
            else {
                failure(-1000);
            }
            return;
        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (!dict)
        {
            NSLog(@"jsonData convert error, code %d, reason: %@", [error code], [error description]);
        }
        
        int statusCode = [[dict objectForKey:@"status"]integerValue];
        if (statusCode==200) {
            completion(dict,operation.responseData);
        }
        else {
            failure(statusCode);
            NSLog(@"Request %@ Failed : %d",operation.request,statusCode);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(-1000);
        NSLog(@"failure");
    }];
    
    [op start];
    
    return op;
}

//Post Request
+ (NSOperation *)httpPostOperation:(NSString*)url parameters:(NSDictionary *)dict completionWithSuccess:(void(^)(NSDictionary *responseDict))completion failure:(void(^)(int errorCode))failure
{
    NSMutableString *string = [NSMutableString stringWithString:url];
    
    /*
    NSArray *keys = dict.allKeys;
    for (int i = 0; i < [keys count]; i++) {
        NSString *key = [keys objectAtIndex:i];
        if (i == 0) {
            if ([url rangeOfString:@"?"].location!= -1) {
                [string appendString:[NSString stringWithFormat:@"?%@=%@",key,[dict objectForKey:key]]];
                continue;
            }
        }
        [string appendString:[NSString stringWithFormat:@"&%@=%@",key,[dict objectForKey:key]]];
    }*/
    NSError *error;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]requestWithMethod:@"POST" URLString:string parameters:dict error:&error];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (!dict)
        {
            NSLog(@"jsonData convert error, code %d, reason: %@", [error code], [error description]);
        }
        
        int statusCode = [[dict objectForKey:@"status"]integerValue];
        if (statusCode==200) {
            completion(dict);
        }
        else {
            failure(statusCode);
            NSLog(@"Request %@ Failed : %d",operation.request,statusCode);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(-1000);
        NSLog(@"failure");
    }];
    
    return op;
}

+ (NSOperation *)httpPostRequest:(NSString*)url parameters:(NSDictionary *)dict completionWithSuccess:(void(^)(NSDictionary *responseDict))completion failure:(void(^)(int errorCode))failure
{
    NSOperation *op = [self httpPostOperation:url parameters:dict completionWithSuccess:^(NSDictionary *responseDict) {
        completion(responseDict);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
    
    [op start];
    return op;
}

//Post Reqeust with multi-part
+ (NSOperation *)httpPostOperation:(NSString*)url parameters:(NSDictionary *)dict header:(NSDictionary *)header
                   body:(NSData *)data dataName:(NSString *)dataName fileName:(NSString *)fileName mimeType:(NSString *)type completionWithSuccess:(void(^)(NSDictionary *responseDict))completion failure:(void(^)(int errorCode))failure
{
    NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    
    NSArray *keys = header.allKeys;
    for (NSString *key in keys) {
        [request addValue:[header objectForKey:key] forHTTPHeaderField:key];
    }
    request.HTTPBody = data;
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (!dict)
        {
            NSLog(@"jsonData convert error, code %d, reason: %@", [error code], [error description]);
        }
        
        int statusCode = [[dict objectForKey:@"status"]integerValue];
        if (statusCode==200) {
            completion(dict);
        }
        else {
            failure(statusCode);
            NSLog(@"Request %@ Failed : %d",operation.request,statusCode);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(-1000);
        NSLog(@"%@",error);
    }];

    return op;
}

+ (NSOperation *)httpPostRequest:(NSString*)url parameters:(NSDictionary *)dict header:(NSDictionary *)header
                            body:(NSData *)data dataName:(NSString *)dataName fileName:(NSString *)fileName mimeType:(NSString *)type completionWithSuccess:(void(^)(NSDictionary *responseDict))completion failure:(void(^)(int errorCode))failure
{
    NSOperation *op = [self httpPostOperation:url parameters:dict header:header body:data dataName:dataName fileName:fileName mimeType:type completionWithSuccess:^(NSDictionary *responseDict) {
        completion (responseDict);
    } failure:^(int errorCode) {
        failure (errorCode);
    }];
    
    [op start];
    return op;
}

+ (NSOperation *)coffeePictureWithTimeStamp:(double)timeInterval completionWithSuccess:(void(^)(NSDictionary *list))completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@GetModifiedCoffeePic?timestamp=%.0f",Server,timeInterval];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *responseDict, NSData *data) {
        completion([responseDict objectForKey:@"result"]);
    } failure:^(int errorCode) {
        
    }];
}

+ (NSOperation *)registerRequestWithUser:(NSString *)user password:(NSString *)password verifyCode:(NSString *)verifyCode completionWithSuccess:(void(^)(NSString *token,NSString *userId))completion failure:(void(^)(int errorCode))failure
{
    NSDictionary *dict = @{@"user":user,@"passwd":password,@"verify":verifyCode};
    NSString *string = [NSString stringWithFormat:@"%@UserRegistion", Server];
    
    return [self httpPostRequest:string parameters:dict completionWithSuccess:^(NSDictionary *dict) {
        completion([dict objectForKey:@"result"],[dict objectForKey:@"userid"]);
    } failure:^(int errorCode){
        failure(errorCode);
    }];
}

+ (NSOperation *)verifyCodeWithUser:(NSString *)user email:(NSString *)email completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@QueryCaptcha?user=%@&purpose=%d&mail=%@", Server, user, VerifyCodeType_BindMail ,email];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *dict,NSData *data) {
        completion();
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)verifyCodeWithUser:(NSString *)user type:(VerifyCodeType)type completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@QueryCaptcha?user=%@&purpose=%d", Server, user, type];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *dict,NSData *data) {
        completion();
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)loginWithUser:(NSString *)user password:(NSString *)password completionWithSuccess:(void(^)(NSString *token, NSString *userId))completion failure:(void(^)(int errorCode))failure
{
    NSDictionary *dict = @{@"user":user,@"passwd":password};
    NSString *string = [NSString stringWithFormat:@"%@UserLogin",Server];
    
    return [self httpPostRequest:string parameters:dict completionWithSuccess:^(NSDictionary *dict) {
        completion([dict objectForKey:@"result"],[dict objectForKey:@"userid"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}
+(NSOperation *)UpdateUserPassword:(NSString*)user OldPassword:(NSString *)oldPassword NewPassword:(NSString*)newPassword Token:(NSString*)token completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure
{
    
    NSDictionary *dict = @{@"user":user,@"token":token,@"oldpasswd":oldPassword,@"newpasswd":newPassword};
    
    NSString *string = [NSString stringWithFormat:@"%@UpdateUserPassword",Server];
    
    return [self httpPostRequest:string parameters:dict completionWithSuccess:^(NSDictionary *dict) {
        completion();
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)logoutWithUser:(NSString *)user token:(NSString *)token completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@UserLogout?user=%@&token=%@",Server,user,token];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *dict,NSData *data) {
        completion();
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}
+ (NSOperation *)MailRestPassword:(NSString *)user completionWithSuccess:(void (^)())completion failure:(void (^)(int))failure
{
    NSString *string = [NSString stringWithFormat:@"%@MailRestPassword?user=%@",Server,user];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *dict, NSData *data) {
        completion();
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}
+ (NSOperation *)ResetUserPassword:(NSString *)user password:(NSString *)password verifyCode:(NSString *)verifyCode completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@ResetUserPassword?user=%@&passwd=%@&verify=%@",Server,user,password,verifyCode];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *dict, NSData *data) {
        completion();
    }failure:^(int errorCdoe){
        failure(errorCdoe);
    }];
}


+ (NSOperation *)userInfo:(NSString *)user token:(NSString *)token completionWithSuccess:(void(^)(NSArray *array))completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@GetUserInfo?user=%@&token=%@",Server,user,token];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *dict,NSData *data) {
        completion([dict objectForKey:@"result"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)modifyUserInfo:(NSDictionary *)dict user:(NSString *)user token:(NSString *)token completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure
{
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary: @{@"user":user, @"token":token}];
    NSArray *keys = [dict allKeys];
    for (NSString *key in keys) {
        [d setObject:[dict objectForKey:key] forKey:key];
    }
    
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@UpdateUserInfo",Server];
    
    return [self httpPostRequest:string parameters:d completionWithSuccess:^(NSDictionary *responseDict) {
        completion();
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)rechargeWithUser:(NSString *)user token:(NSString *)token money:(NSString *)money completionWithSuccess:(void(^)(NSString *response))completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@GetPaymentId?user=%@&token=%@&money=%@",Server,user,token,money];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *dict,NSData *data) {
        completion([dict objectForKey:@"result"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)remainWithUser:(NSString *)user token:(NSString *)token completionWithSuccess:(void(^)(NSNumber *response))completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@GetUserBalance?user=%@&token=%@",Server,user,token];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *dict,NSData *data) {
        completion([dict objectForKey:@"result"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)tradeWithUser:(NSString *)user token:(NSString *)token page:(NSInteger)page completionWithSuccess:(void(^)(NSArray *array))completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@GetUserTradeRecord?user=%@&token=%@&page=%d&page_entrys=%d",Server,user,token,page,PAGE_ENTRYS];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *dict,NSData *data) {
        completion([dict objectForKey:@"result"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)modifyAvatarWithUser:(NSString *)user token:(NSString *)token avatar:(NSData *)avatarData completionWithSuccess:(void(^)(NSString *response))completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@UpdateUserPhoto",Server];
    NSDictionary *dict = @{@"user": user, @"token": token};

    return [self httpPostRequest:string parameters:nil
                   header:dict body:avatarData dataName:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpg" completionWithSuccess:^(NSDictionary *responseDict) {
        completion([responseDict objectForKey:@"result"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)avatarWithUser:(NSString *)user token:(NSString *)token offset:(NSInteger)offset size:(AvatarSize)size completionWithSuccess:(void(^)(NSString *))completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@GetUserPhoto?user=%@&token=%@&offset=%d&size=%d",Server,user,token,offset,size];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *dict,NSData *data) {
        completion([dict objectForKey:@"result"]);
        
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)productListAtPage:(NSInteger)page entrys:(NSInteger)entrys completionWithSuccess:(void(^)(NSArray *arr))completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@GetCoffeeInofList?page=%d&page_entrys=%d",Server,page,entrys];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *responseDict, NSData *data) {
        completion([responseDict objectForKey:@"result"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)submitOrderWithUser:(NSString *)user token:(NSString *)token content:(NSString *)content dosing:(NSString *)dosing source:(OrderSource)source completionWithSuccess:(void(^)(NSArray *arr, NSArray *infoArr,NSString *orderId))completion failure:(void(^)(int errorCode))failure
{
    NSDictionary *dict = @{@"user":user,@"token":token,@"content":content,@"dosing":dosing,@"source":[NSString stringWithFormat:@"%d",source]};
    
    NSString *string = [NSString stringWithFormat:@"%@SubmitOrders",Server];
    
    return [self httpPostRequest:string parameters:dict completionWithSuccess:^(NSDictionary *responseDict) {
        completion([responseDict objectForKey:@"price"],[responseDict objectForKey:@"info"],[responseDict objectForKey:@"indent"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)payOrderWithUser:(NSString *)user token:(NSString *)token indent:(NSString *)indent method:(PayType)method useBalance:(BOOL)use completionWithSuccess:(void(^)(NSString *result))completion failure:(void(^)(int errorCode))failure
{
    NSDictionary *dict = @{@"user":user,@"token":token,@"indent":indent,@"method":[NSString stringWithFormat:@"%d",method],@"balance":use?@"true":@"false"};
    
    NSString *string = [NSString stringWithFormat:@"%@PayOrders",Server];
    
    return [self httpPostRequest:string parameters:dict completionWithSuccess:^(NSDictionary *responseDict) {
        completion([responseDict objectForKey:@"result"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)dossingCompletionWithSuccess:(void(^)(NSArray *dosingArr))completion failure:(void(^)(int errorCode))failure {
    NSString *string = [NSString stringWithFormat:@"%@GetDosing",Server];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *responseDict, NSData *data) {
        completion([responseDict objectForKey:@"result"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)orderListWithUser:(NSString *)user token:(NSString *)token page:(NSInteger)page type:(OrderType)type completionWithSuccess:(void(^)(NSArray *array))completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@GetUserPayedIndent?user=%@&token=%@&page=%d&page_entrys=%d&type=%d",Server,user,token,page,PAGE_ENTRYS,type];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *responseDict, NSData *data) {
        completion([responseDict objectForKey:@"result"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)favListWithUser:(NSString *)user token:(NSString *)token completionWithSuccess:(void(^)(NSArray *array))completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@GetCollect?user=%@&token=%@",Server,user,token];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *responseDict, NSData *data) {
        completion([responseDict objectForKey:@"result"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)addFavWithUser:(NSString *)user token:(NSString *)token coffee:(NSString *)coffeeId dosing:(NSString*)dosing completionWithSuccess:(void(^)(NSDictionary *dict))completion failure:(void(^)(int errorCode))failure
{
    NSDictionary *dict = @{@"user":user, @"token":token, @"coffeeid":coffeeId, @"dosing":dosing};
    NSString *string = [NSString stringWithFormat:@"%@CollectCoffee",Server];
    
    return [self httpPostRequest:string parameters:dict completionWithSuccess:^(NSDictionary *responseDict) {
        completion([responseDict objectForKey:@"result"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)removeFavWithUser:(NSString *)user token:(NSString *)token coffee:(NSString *)coffeeId dosing:(NSString*)dosing completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure
{
    NSDictionary *dict = @{@"user":user, @"token":token, @"coffeeid":coffeeId, @"dosing":dosing};
    NSString *string = [NSString stringWithFormat:@"%@DeleteCollect",Server];
    
    return [self httpPostRequest:string parameters:dict completionWithSuccess:^(NSDictionary *responseDict) {
        completion();
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)addToCartWithUser:(NSString *)user token:(NSString *)token coffee:(NSString *)coffeeId dosing:(NSString*)dosing num:(NSInteger)num completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure
{
    NSDictionary *dict = @{@"user":user, @"token":token, @"coffeeid":coffeeId, @"dosing":dosing, @"num":[NSString stringWithFormat:@"%d",num]};
    NSString *string = [NSString stringWithFormat:@"%@AddShoppingCart",Server];
    
    return [self httpPostRequest:string parameters:dict completionWithSuccess:^(NSDictionary *responseDict) {
        completion();
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)removeFromCartWithUser:(NSString *)user token:(NSString *)token coffee:(NSString *)content completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure
{
    NSDictionary *dict = @{@"user":user, @"token":token, @"content":content };
    NSString *string = [NSString stringWithFormat:@"%@DeleteShoppingCart",Server];
    
    return [self httpPostRequest:string parameters:dict completionWithSuccess:^(NSDictionary *responseDict) {
        completion();
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)modifyCartWithUser:(NSString *)user token:(NSString *)token coffee:(NSString *)content coffeeNum:(NSString *)coffeeNum completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure
{
    NSDictionary *dict = @{@"user":user, @"token":token, @"content":content, @"num":coffeeNum};
    NSString *string = [NSString stringWithFormat:@"%@ModifyShoppingCart",Server];
    
    return [self httpPostRequest:string parameters:dict completionWithSuccess:^(NSDictionary *responseDict) {
        completion();
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)cartListWithUser:(NSString *)user token:(NSString *)token page:(NSInteger)page completionWithSuccess:(void(^)(NSArray *arr))completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@GetShoppingCart?user=%@&token=%@&page=%d&page_entrys=%d",Server,user,token,page,PAGE_ENTRYS];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *responseDict, NSData *data) {
        completion([responseDict objectForKey:@"result"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)takeProductWithUser:(NSString *)user coffeeid:(NSString*)coffeeid completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@GetCoffee?user=%@&coffeeindent=%@",Server,user,coffeeid];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *responseDict, NSData *data) {
        completion();
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)returnProductWithUser:(NSString *)user token:(NSString *)token coffeeid:(NSString*)coffeeid completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@CoffeeRefund?user=%@&token=%@&coffeeindent=%@",Server,user,token,coffeeid];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *responseDict, NSData *data) {
        completion();
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)versionCompletionWithSuccess:(void(^)(NSString *version, NSString *updateUrl))completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@GetVersion?system=1",Server];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *responseDict, NSData *data) {
        completion([responseDict objectForKey:@"result"],[responseDict objectForKey:@"updateurl"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)commentListWithCoffeeId:(NSString *)coffeeId page:(NSInteger)page completionWithSuccess:(void(^)(NSArray *array))completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@GetCoffeeComments?coffeeid=%@&page=%d&page_entrys=%d",Server,coffeeId,page,PAGE_ENTRYS];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *responseDict, NSData *data) {
        completion([responseDict objectForKey:@"result"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)commentWithUser:(NSString *)user token:(NSString *)token coffeeId:(NSString *)coffeeId comment:(NSString *)comment pic:(NSString*)commentPic longitude:(float)longitude latitude:(float)latitude completionWithSuccess:(void(^)())completion failure:(void(^)(int errorCode))failure
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: @{@"user":user, @"token":token, @"coffeeindent":coffeeId, @"comment":comment, @"commentPic":commentPic}];
    
    if (longitude >0 && latitude > 0) {
        [dict setObject:[NSNumber numberWithFloat:longitude] forKey:@"longitude"];
        [dict setObject:[NSNumber numberWithFloat:latitude] forKey:@"latitude"];
    }
    
    NSString *string = [NSString stringWithFormat:@"%@CoffeeComment",Server];
    
    return [self httpPostRequest:string parameters:dict completionWithSuccess:^(NSDictionary *responseDict) {
        completion();
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)uploadCommentPhotoOPWithUser:(NSString *)user token:(NSString *)token coffeeId:(NSString *)coffeeId photo:(NSData *)photo completionWithSuccess:(void(^)(NSString *pic))completion failure:(void(^)(int errorCode))failure
{
    NSDictionary *dict = @{@"user":user, @"token":token, @"coffeeindent":coffeeId};
    NSString *string = [NSString stringWithFormat:@"%@UpdateCommentPic",Server];
    
    return [self httpPostOperation:string parameters:nil header:dict body:photo dataName:@"commentPhoto"fileName:@"commentPhoto.jpg" mimeType:@"image/jpg" completionWithSuccess:^(NSDictionary * responseDict) {
        completion([responseDict objectForKey:@"result"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)cultureListWithLastId:(NSString *)lastid type:(CultureListType)type completionWithSuccess:(void(^)(NSArray *arr))completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@GetCoffeeCulture?lastid=%@&length=%d&type=%d",Server,lastid,0,type];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *responseDict, NSData *data) {
        completion([responseDict objectForKey:@"result"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

+ (NSOperation *)coffeeMachineListWithTimestamp:(NSString *)timeStamp CompletionWithSuccess:(void(^)(NSArray *dict,NSString* timeStamp))completion failure:(void(^)(int errorCode))failure
{
    NSString *string = [NSString stringWithFormat:@"%@QueryNearbyCoffeeMachine?longitude=1&latitude=1&timestamp=%@",Server,timeStamp];
    
    return [self httpGetRequest:string completionWithSuccess:^(NSDictionary *responseDict, NSData *data) {
        completion([responseDict objectForKey:@"result"],[responseDict objectForKey:@"timestamp"]);
    } failure:^(int errorCode) {
        failure(errorCode);
    }];
}

@end
