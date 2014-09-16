//
//  NearbyTableViewCell.m
//  coffeeMachine
//
//  Created by Beifei on 6/20/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "NearbyTableViewCell.h"
#import "AvatarImageView.h"

@interface NearbyTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet AvatarImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *coffeeIcon;
@property (weak, nonatomic) IBOutlet UILabel *status;
@end


@implementation NearbyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, 320, 0.5)];
    bottomLine.backgroundColor = SeperatorColor;
    [self.contentView addSubview:bottomLine];
    
    UIView *seperator = [[UIView alloc]initWithFrame:CGRectMake(19, 60.5, 282, 0.5)];
    seperator.backgroundColor = SeperatorColor;
    [self.contentView addSubview:seperator];
    
    [self.avatar setImage:[UIImage imageNamed:@"img_avatar"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
