//
//  PayResultViewController.h
//  coffeeMachine
//
//  Created by Beifei on 6/26/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    ResultType_Pay,
    ResultType_Recharge
} ResultType;

@interface PayResultViewController : UIViewController

@property (nonatomic, assign) ResultType type;
@property (nonatomic, assign) BOOL status;

- (id)initWithType:(ResultType)type status:(BOOL)status;

@end
