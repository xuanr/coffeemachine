//
//  NoImagelabelVIew.m
//  coffeeMachine
//
//  Created by xuanr on 14-5-30.
//  Copyright (c) 2014年 iChuansuo. All rights reserved.
//

#import "NoImagelabelVIew.h"
#define leftOffset 0
@implementation NoImagelabelVIew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initUI];
}

- (void)initUI
{

    self.textField = [[UITextField alloc]init];
}



- (void)setTextField:(UITextField *)textField
{
    [_textField removeFromSuperview];
    _textField = textField;
    [_textField setFrame:CGRectMake(2*leftOffset, self.frame.size.height/4.0, 150, self.frame.size.height)];
    [self addSubview:_textField];
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{

    
    [_textField setFrame:CGRectMake(2*leftOffset, 0, 150, self.frame.size.height)];
    [_textField setNeedsDisplay];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
