//
//  NSString+Util.m
//  coffeeMachine
//
//  Created by Beifei on 5/28/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Util)

- (BOOL)isEmpty
{
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

- (BOOL)checkPhoneValid
{
    if ([[self trim] length]==11) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)checkPasswordValid
{
    int len = [[self trim]length];
    
    if (len>=6&&len<=12) {
        return YES;
    }
    return NO;
}

- (BOOL)checkEmailValid
{
    
    NSString *regexMail = @"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z]+.[A-Za-z]+";
    
    NSPredicate *testMail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexMail];
    
    if ([testMail evaluateWithObject:self]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
