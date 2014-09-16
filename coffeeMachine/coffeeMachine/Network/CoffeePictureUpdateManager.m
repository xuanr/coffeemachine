//
//  CoffeePictureUpdateManager.m
//  coffeeMachine
//
//  Created by Beifei on 7/4/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "CoffeePictureUpdateManager.h"
#import "Util.h"

@interface CoffeePictureUpdateManager()

@property (strong, nonatomic) NSMutableDictionary *coffeePictureDict;
@property (strong, nonatomic) NSOperation *coffeePicListOperation;

@end

@implementation CoffeePictureUpdateManager

+ (CoffeePictureUpdateManager*)sharedManager {
    static dispatch_once_t once;
    static CoffeePictureUpdateManager *sharedManager;
    dispatch_once(&once, ^ {
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)updateCoffeePicList
{
    if (self.coffeePicListOperation) {
        return;
    }
    
    __weak CoffeePictureUpdateManager *obj = self;
    NSTimeInterval lastCoffeeListTime = [[[NSUserDefaults standardUserDefaults]objectForKey:lastCoffeePicListCheck]floatValue];
    NSTimeInterval currentTime = [[NSDate date]timeIntervalSince1970];
    if (lastCoffeeListTime == 0 || currentTime - lastCoffeeListTime >= 24*60*60*7) {
        self.coffeePicListOperation = [HttpRequest coffeePictureWithTimeStamp:[[[NSUserDefaults standardUserDefaults]objectForKey:lastCoffeePicListUpate]floatValue] completionWithSuccess:^(NSDictionary *dict) {
            obj.coffeePicListOperation = nil;
            NSString *path =  [[NSBundle mainBundle] pathForResource:@"coffeePicture" ofType:@"plist"];
            if (path && [Util fileExists:path]) {
                self.coffeePictureDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
            }
            else {
                self.coffeePictureDict = [NSMutableDictionary dictionary];
            }
            [self.coffeePictureDict setDictionary:dict];
            [self.coffeePictureDict writeToFile:@"coffeePicture.plist" atomically:YES];
            [obj checkPicture];
        } failure:^(int errorCode) {
            obj.coffeePicListOperation = nil;
            [obj checkPicture];
        } ];
    }
    else {
        [self checkPicture];
    }
}

- (void)checkPicture
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *path =  [[NSBundle mainBundle] pathForResource:@"coffeePicture" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        NSArray *allKeys = [dict allKeys];
        for (NSString *key in allKeys) {
            NSString *url = [dict objectForKey:key];
            [[PictureDownloadManager sharedManager]downloadPicture:url];
        }
    });
}

- (UIImage *)coffeePictureOfId:(NSString *)key atUrl:(NSString *)coffeeUrl
{
    if (coffeeUrl && ![coffeeUrl isEqual:[NSNull null]] &&![coffeeUrl isEqualToString:@""]) {
        [self.coffeePictureDict setObject:coffeeUrl forKey:key];
    }
    else {
        coffeeUrl = [self.coffeePictureDict objectForKey:key];
    }
    
    if (!coffeeUrl || [coffeeUrl isEqual:[NSNull null]]) {
        return nil;
    }
    
    UIImage *img = [[PictureDownloadManager sharedManager]pictureOfUrl:coffeeUrl];
    
    if (!img) {
        [[NSNotificationCenter defaultCenter]addObserverForName:PictureDownloadFinishedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            NSDictionary *info = [note userInfo];
            UIImage *img = [info objectForKey:coffeeUrl];
            if (img) {
                [[NSNotificationCenter defaultCenter]postNotificationName:CoffeePictureDownloadFinished object:nil userInfo:@{key: img}];
            }
        }];
    }
    
    return img;
}

@end
