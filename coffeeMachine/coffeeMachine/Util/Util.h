//
//  Util.h
//  coffeeMachine
//
//  Created by Beifei on 7/7/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (NSString *)uuid;
+ (BOOL)fileExists:(NSString *)fileUrl;
+ (NSString *)timeString:(NSTimeInterval)interval;
+ (NSString *)distanceString:(double)distance;

@end
