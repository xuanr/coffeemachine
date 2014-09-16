//
//  LoginViewController.h
//  coffeeMachine
//
//  Created by Beifei on 5/19/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BounceViewController.h"
#import "RegisterViewController.h"

@protocol LoginDelegate <NSObject>

@required
- (void)loginSuccess:(id)sender;

@end

@interface LoginViewController : BounceViewController <UITextFieldDelegate,UIGestureRecognizerDelegate,RegisterDelegate>

@property (weak, nonatomic) id<LoginDelegate> delegate;

@end
