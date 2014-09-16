//
//  UserTextTableViewCell.m
//  coffeeMachine
//
//  Created by Beifei on 5/29/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "UserTextTableViewCell.h"

@implementation UserTextTableViewCell

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
    // Initialization code
    [super awakeFromNib];
    
    self.textLabel.textColor = GrayTextColor;
    self.detailTextLabel.textColor = GrayTextColor;
    
    UIImageView *accessory = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_acc"]];
    CGRect frame = accessory.frame;
    frame.origin.x = 278;
    frame.origin.y = (self.frame.size.height - accessory.frame.size.height)/2;
    [accessory setFrame:frame];
    [self.contentView addSubview:accessory];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x = 27;
    self.textLabel.frame = frame;
    
    frame = self.imageView.frame;
    frame.origin.x = 27;
    self.imageView.frame = frame;
    
    frame = self.detailTextLabel.frame;
    frame.origin.x = frame.origin.x - 50;
    self.detailTextLabel.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
