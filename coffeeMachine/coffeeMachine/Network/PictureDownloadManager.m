//
//  PictureDownloadManager.m
//  coffeeMachine
//
//  Created by Beifei on 7/4/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "PictureDownloadManager.h"
#import "FileDownloader.h"
#import "Util.h"

@interface PictureDownloadManager()

@property (strong, nonatomic) NSMutableDictionary *pictureMap;

@end

@implementation PictureDownloadManager

+ (PictureDownloadManager*)sharedManager {
    static dispatch_once_t once;
    static PictureDownloadManager *sharedManager;
    dispatch_once(&once, ^ {
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    if (self = [super init]) {
        NSString *path =  [[NSBundle mainBundle] pathForResource:@"pictureMap" ofType:@"plist"];
        if (path) {
            self.pictureMap = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        }
        else {
            self.pictureMap = [NSMutableDictionary dictionary];
        }
    }
    return self;
}

- (UIImage *)pictureOfUrl:(NSString *)url
{
    NSString *fileUrl = [self.pictureMap objectForKey:url];
    if (fileUrl && [Util fileExists:fileUrl]) {
        return [UIImage imageWithContentsOfFile:fileUrl];
    }
    
    [self downloadPicture:url];
    return nil;
}

- (void)downloadPicture:(NSString *)url
{
    __weak PictureDownloadManager *obj = self;
    [[FileDownloader sharedManager]downloadFile:url completionWithSuccess:^(NSString *filePath) {
        if (filePath && [Util fileExists:filePath] && [UIImage imageWithContentsOfFile:filePath]) {
            [obj.pictureMap setObject:filePath forKey:url];
            [[NSNotificationCenter defaultCenter]postNotificationName:PictureDownloadFinishedNotification object:nil userInfo:@{url:[UIImage imageWithContentsOfFile:filePath]}];
        }
    } failure:^(int errorCode) {
        
    }];
}

@end
