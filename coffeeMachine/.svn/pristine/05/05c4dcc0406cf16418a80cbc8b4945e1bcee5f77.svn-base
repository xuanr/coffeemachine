//
//  FileDownloader.m
//  coffeeMachine
//
//  Created by Beifei on 7/4/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "FileDownloader.h"
#import "AFNetworking.h"
#import "Util.h"

@interface FileDownloader()

@property (nonatomic, strong) NSMutableDictionary *operationDict;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation FileDownloader

+ (FileDownloader*)sharedManager {
    static dispatch_once_t once;
    static FileDownloader *sharedManager;
    dispatch_once(&once, ^ {
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        self.operationDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)downloadFile:(NSString *)fileUrl completionWithSuccess:(void(^)(NSString *filePath))completion failure:(void(^)(int errorCode))failure
{
    if ([self.operationDict objectForKey:fileUrl]) {
        return;
    }
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]]];
    
    [self.operationDict setObject:op forKey:fileUrl];
    [self.operationQueue addOperation:op];
    
    __weak FileDownloader *obj = self;
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [obj.operationDict removeObjectForKey:fileUrl];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *appDocumentPath = [[NSString alloc]initWithFormat:@"%@/",[paths objectAtIndex:0]];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.jpg",appDocumentPath,[Util uuid]];
        
        NSData *data = [operation responseData];
        [data writeToFile:filePath atomically:YES];
        
        completion(filePath);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [obj.operationDict removeObjectForKey:fileUrl];
        failure(error.code);
    }];
    
    [op start];
}

@end
