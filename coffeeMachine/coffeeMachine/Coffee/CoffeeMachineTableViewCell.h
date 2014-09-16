//
//  CoffeeMachineTableViewCell.h
//  coffeeMachine
//
//  Created by xuanr on 14-6-13.
//  Copyright (c) 2014年 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoffeeNumView.h"

@interface CoffeeMachineTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *data;
@property (assign, nonatomic) BOOL isWhite;

- (void)setWhiteCell:(BOOL)white last:(BOOL)isLastWhite;

@end
