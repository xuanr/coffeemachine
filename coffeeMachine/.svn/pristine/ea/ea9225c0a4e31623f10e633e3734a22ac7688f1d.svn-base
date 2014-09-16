//
//  Util.m
//  coffeeMachine
//
//  Created by Beifei on 7/7/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSString *)uuid
{
    CFUUIDRef uuid = CFUUIDCreate(nil);
	NSString *uuidString = CFBridgingRelease(CFUUIDCreateString(nil, uuid));
	CFRelease(uuid);
    return uuidString;
}

+ (BOOL)fileExists:(NSString *)fileUrl
{
    return [[NSFileManager defaultManager] fileExistsAtPath:fileUrl];
}

+ (NSString *)timeString:(NSTimeInterval)interval
{
    {
        NSDate* dat = [NSDate date];
        NSTimeInterval now=[dat timeIntervalSince1970];
        NSString *timeString=nil;
        
        NSTimeInterval cha=now-interval/1000;
        
        if (cha/3600<1) {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
            return timeString;
            
        }
        else if (cha/3600>1&&cha/86400<1) {
            timeString = [NSString stringWithFormat:@"%f", cha/3600];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@小时前", timeString];
            return timeString;
        }
        else {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            return [dateFormatter stringFromDate:date];
        }
    }
}

+ (NSString *)distanceString:(double)distance
{
    if (distance > 1000) {
        return [NSString stringWithFormat:@"%.2f KM",distance/1000];
    }
    else {
        return [NSString stringWithFormat:@"%.2f M",distance];
    }
}

@end
