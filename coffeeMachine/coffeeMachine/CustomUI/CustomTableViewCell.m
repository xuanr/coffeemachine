//
//  CustomTableViewCell.m
//  coffeeMachine
//
//  Created by Beifei on 5/22/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

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
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, 320, 0.5)];
    line.backgroundColor = SeperatorColor;
    [self addSubview:line];
    
    self.contentView.backgroundColor = CellBgColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
