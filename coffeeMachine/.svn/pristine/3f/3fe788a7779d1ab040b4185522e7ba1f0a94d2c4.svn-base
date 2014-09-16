//
//  FileDownloader.h
//  coffeeMachine
//
//  Created by Beifei on 7/4/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDownloader : NSObject

+ (FileDownloader*)sharedManager;
- (void)downloadFile:(NSString *)fileUrl completionWithSuccess:(void(^)(NSString *filePath))completion failure:(void(^)(int errorCode))failure;

@end
