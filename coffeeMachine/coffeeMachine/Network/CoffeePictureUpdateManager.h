//
//  CoffeePictureUpdateManager.h
//  coffeeMachine
//
//  Created by Beifei on 7/4/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureDownloadManager.h"

#define CoffeePictureDownloadFinished @"coffeePictureDownloadFinished"

@interface CoffeePictureUpdateManager : NSObject

+ (CoffeePictureUpdateManager*)sharedManager;
- (void)updateCoffeePicList;
- (UIImage *)coffeePictureOfId:(NSString *)key atUrl:(NSString *)coffeeUrl;

@end
