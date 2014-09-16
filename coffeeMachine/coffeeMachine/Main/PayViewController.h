//
//  PayViewController.h
//  coffeeMachine
//
//  Created by Beifei on 6/25/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioGroup.h"

@interface PayViewController : UIViewController <RadioGroupDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *coffeeArr;
@property (nonatomic, strong) NSArray *valueArr;
@property (nonatomic, strong) NSString *indent;

@end
