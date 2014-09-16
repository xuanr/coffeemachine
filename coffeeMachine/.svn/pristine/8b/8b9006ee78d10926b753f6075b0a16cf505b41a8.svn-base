//
//  FavoriteTableViewCell.h
//  coffeeMachine
//
//  Created by Beifei on 6/12/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FavoriteTableViewCellDelegate <NSObject>

- (void)addToCart:(NSDictionary *)fav;

@end

@interface FavoriteTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *favDict;
@property (weak, nonatomic) id<FavoriteTableViewCellDelegate> delgate;

@end
