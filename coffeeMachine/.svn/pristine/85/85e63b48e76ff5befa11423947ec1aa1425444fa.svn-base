//
//  UIViewController+NetworkCheck.m
//  coffeeMachine
//
//  Created by Beifei on 6/17/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "UIViewController+NetworkCheck.h"
#import "NetworkDetector.h"

@implementation UIViewController (NetworkCheck)

- (void)networkCheck
{
    if (![[NetworkDetector sharedDetector]isReachable]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Network_NOT_REACHABLE", nil)];
    }
}

@end
