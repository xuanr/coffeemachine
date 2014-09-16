//
//  CartTableViewCell.h
//  coffeeMachine
//
//  Created by Beifei on 6/12/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeValue.h"

@protocol CartTableViewCellDelegate <NSObject>

- (void)cartChange:(NSDictionary *)cart;

@end

@interface CartTableViewCell : UITableViewCell <ChangeValueDelegate>

@property (nonatomic, strong) NSMutableDictionary *cart;
@property (weak, nonatomic) IBOutlet UIView *editQtyView;

@property (nonatomic, assign) BOOL isSelected;

@property (weak, nonatomic) id<CartTableViewCellDelegate> delegate;

@end
