//
//  CoffeeMakeView.h
//  coffeeMachine
//
//  Created by Beifei on 6/18/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeValue.h"


@protocol IndgredientCellDelegate <NSObject>

- (void)valueChanged:(NSInteger)value ofSender:(id)sender;

@end

@protocol CoffeeMakeViewDelegate <NSObject>

@required
- (void)close;
- (void)addToFav:(NSString *)content dosing:(NSString *)dosing completionWithSuccess:(void(^)())completion failure:(void(^)())failure;
- (void)addToCart:(NSString *)content dosing:(NSString *)dosing num:(NSInteger)num;
- (void)buyContent:(NSString *)content dosing:(NSString *)dosing coffee:(NSDictionary *)coffeeDict;

@end

@interface CoffeeMakeView : UIView <UITableViewDelegate,UITableViewDataSource,IndgredientCellDelegate>

@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, assign) id<CoffeeMakeViewDelegate> delegate;

@end
