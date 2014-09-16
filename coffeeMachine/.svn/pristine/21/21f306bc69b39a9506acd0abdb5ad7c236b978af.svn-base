//
//  UserTableViewCell.m
//  coffeeMachine
//
//  Created by Beifei on 5/19/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "UserTableViewCell.h"

#define iconLeftOffset 20
#define imageWidth 30
#define labelLeftOffset iconLeftOffset+imageWidth+10

@implementation UserTableViewCell

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
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(iconLeftOffset, (self.contentView.frame.size.height - imageWidth)/2, imageWidth, imageWidth)];
    [self.contentView addSubview:self.icon];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(labelLeftOffset, 0, imageWidth, imageWidth)];
    [self.contentView addSubview:self.label];
    
    self.remindPoint = [[UIImageView alloc]init];
    [self.contentView addSubview:self.remindPoint];
    self.remindPoint.hidden = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews
{
    self.contentView.center = CGPointMake(self.contentView.center.x, self.frame.size.height/2);
    self.accessoryView.center = CGPointMake(self.accessoryView.center.x, self.icon.center.y);
    
    CGPoint center = self.label.center;
    center.y = self.icon.center.y;
    self.label.center = center;
    
    [self.remindPoint setFrame:CGRectMake(self.label.frame.origin.x+self.label.frame.size.width, self.label.frame.origin.y, self.remindPoint.frame.size.width, self.remindPoint.frame.size.height)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
