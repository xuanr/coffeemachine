//
//  CustomPreviewController.h
//  coffeeMachine
//
//  Created by Beifei on 7/18/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <QuickLook/QuickLook.h>

@protocol CustomPreviewControllerDelegate <NSObject>

- (void)deleteAtIndex:(NSInteger)index;

@end

@interface CustomPreviewController : UIViewController

@property (weak, nonatomic) id<QLPreviewControllerDelegate,CustomPreviewControllerDelegate> delegate;
@property (weak, nonatomic) id<QLPreviewControllerDataSource> dataSource;
@property (assign, nonatomic) NSInteger currentPreviewItemIndex;

@end
