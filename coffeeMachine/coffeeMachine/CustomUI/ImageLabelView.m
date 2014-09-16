//
//  ImageLabelView.m
//  coffeeMachine
//
//  Created by Beifei on 5/21/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "ImageLabelView.h"

#define leftOffset 27

@implementation ImageLabelView

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
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    self.textField = [[UITextField alloc]init];
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)addSeperatorLine
{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
    line.backgroundColor = SeperatorColor;
    [self addSubview:line];
}

- (void)setIcon:(UIImageView *)icon
{
    [_icon removeFromSuperview];
    _icon = icon;
    [self addSubview:_icon];
    
    [self setNeedsDisplay];
}

- (void)setTextField:(UITextField *)textField
{
    [_textField removeFromSuperview];
    _textField = textField;
    [_textField setFrame:CGRectMake(2*leftOffset+_icon.frame.size.width, 0, 230, self.frame.size.height)];
    [self addSubview:_textField];
    
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [_icon setFrame:CGRectMake(leftOffset, (self.frame.size.height-_icon.frame.size.height)/2, _icon.frame.size.width, _icon.frame.size.height)];
    
    [_textField setFrame:CGRectMake(2*leftOffset+self.icon.frame.size.width, _icon.frame.origin.y, 230, _icon.frame.size.height)];
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
