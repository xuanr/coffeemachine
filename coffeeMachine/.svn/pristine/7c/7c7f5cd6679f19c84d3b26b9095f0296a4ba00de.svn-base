//
//  OrderDetailTableViewCell.h
//  coffeeMachine
//
//  Created by Beifei on 6/20/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    CoffeeStatus_Untake,
    CoffeeStatus_Taken,
    CoffeeStatus_Back
} CoffeeStatus;

@protocol OrderDetailTableViewCellDelegate <NSObject>

- (void)take:(NSDictionary *)coffee;
- (void)cancel:(NSDictionary *)coffee;
- (void)comment:(NSDictionary *)coffee;
- (void)location:(NSDictionary *)coffee;
- (void)feedback:(NSDictionary *)coffee;

@end

@interface OrderDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *coffee;

@property (weak, nonatomic) id<OrderDetailTableViewCellDelegate> delegate;

@end
