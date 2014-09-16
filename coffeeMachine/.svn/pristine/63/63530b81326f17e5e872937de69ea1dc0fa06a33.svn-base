//
//  CoffeeMachineTableViewCell.m
//  coffeeMachine
//
//  Created by xuanr on 14-6-13.
//  Copyright (c) 2014年 iChuansuo. All rights reserved.
//

#import "CoffeeMachineTableViewCell.h"
#import "Util.h"

@interface CoffeeMachineTableViewCell()

@property(strong, nonatomic) IBOutlet UILabel* label;
@property(strong, nonatomic) IBOutlet UILabel* add;
@property(strong, nonatomic) IBOutlet UILabel* distance;

@property(strong, nonatomic) UIView *line;

@end

@implementation CoffeeMachineTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)initUI
{
    self.line = [[UIView alloc]initWithFrame:CGRectMake(10, self.frame.size.height - 0.5, 300, 0.5)];
    self.line.backgroundColor = SeperatorColor;
    [self.contentView addSubview:self.line];
}

- (void)setWhiteCell:(BOOL)white last:(BOOL)isLastWhite
{
    if (white) {
        self.backgroundColor = [UIColor whiteColor];
        self.isWhite = YES;
    }
    else {
        self.backgroundColor = CellBgColor;
        self.isWhite = NO;
    }
    
    if (!isLastWhite) {
        [self.line setFrame:CGRectMake(10, self.frame.size.height - 0.5, 300, 0.5)];
        self.line.backgroundColor = SeperatorColor;
    }
    else {
        [self.line setFrame:CGRectMake(0, self.frame.size.height - 0.5, 320, 0.5)];
        self.line.backgroundColor = DarkSeperatorColor;
    }
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    NSDictionary *dict = [data objectForKey:@"info"];
    self.label.text = [NSString stringWithFormat:@"No.%@",[dict objectForKey:@"machineid"]];
    self.add.text = [dict objectForKey:@"address"];
    self.distance.text = [Util distanceString:[[data objectForKey:@"distance"]doubleValue]];
    
    [self setNeedsDisplay];
}

- (void)awakeFromNib
{
    [self initUI];
}

@end
