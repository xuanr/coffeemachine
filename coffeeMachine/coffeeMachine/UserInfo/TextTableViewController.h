//
//  TextTableViewController.h
//  coffeeMachine
//
//  Created by Beifei on 5/22/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMTableViewController.h"

typedef enum
{
    TextTableViewControllerType_Nick,
    TextTableViewControllerType_Mobile,
} TextTableViewControllerType;

@interface TextTableViewController : CMTableViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSString *text;

@end
