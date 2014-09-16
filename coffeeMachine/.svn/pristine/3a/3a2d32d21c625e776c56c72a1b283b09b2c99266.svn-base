//
//  RegisterViewController.h
//  coffeeMachine
//
//  Created by Beifei on 5/19/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BounceViewController.h"

@protocol RegisterDelegate <NSObject>

@required
- (void)registerSuccess;

@end

@interface RegisterViewController : BounceViewController <UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<RegisterDelegate> delegate;

@end
