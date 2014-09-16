//
//  NearbyCell.h
//  coffeeMachine
//
//  Created by Beifei on 6/19/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarImageView.h"

@protocol NearbyCellDelegate <NSObject>
@required
- (void)selectUser;

@end

@interface NearbyCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) AvatarImageView *avatar;

@property (weak, nonatomic) id<NearbyCellDelegate>delegate;

@end
