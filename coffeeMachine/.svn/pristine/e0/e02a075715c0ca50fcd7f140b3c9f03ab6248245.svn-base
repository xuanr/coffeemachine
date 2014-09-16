//
//  CoffeeCell.h
//  coffeeMachine
//
//  Created by Beifei on 6/17/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CoffeeCellDelegate <NSObject>

- (void)comment:(NSDictionary *)dict;

@end

@interface CoffeeCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *dict;

@property (weak, nonatomic) id<CoffeeCellDelegate> delegate;

@end
