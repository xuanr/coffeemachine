//
//  CommentViewController.h
//  coffeeMachine
//
//  Created by Beifei on 6/20/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "QBImagePickerController.h"
#import "CustomPreviewController.h"

@interface CommentViewController : UIViewController <UITextViewDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,CustomPreviewControllerDelegate>

@property (strong, nonatomic) NSDictionary *coffee;

@end
