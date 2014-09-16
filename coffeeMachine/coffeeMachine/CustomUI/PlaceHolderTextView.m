//
//  PlaceHolderTextView.m
//  coffeeMachine
//
//  Created by Beifei on 7/16/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "PlaceHolderTextView.h"

@interface PlaceHolderTextView ()

@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation PlaceHolderTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addPlaceHolder];
    }
    return self;
}

- (void)awakeFromNib
{
    [self addPlaceHolder];
}

- (void)addPlaceHolder
{
    self.placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
    self.placeHolderLabel.textColor = [UIColor lightGrayColor];
    self.placeHolderLabel.numberOfLines = 0;
    self.placeHolderLabel.font = self.font;
    [self addSubview:self.placeHolderLabel];
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.placeHolderLabel.text = placeHolder;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
 */
- (BOOL)becomeFirstResponder
{
    self.placeHolderLabel.hidden = YES;
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    if ([self.text isEqualToString:@""]) {
        self.placeHolderLabel.hidden = NO;
    }
    return [super resignFirstResponder];
}

@end
