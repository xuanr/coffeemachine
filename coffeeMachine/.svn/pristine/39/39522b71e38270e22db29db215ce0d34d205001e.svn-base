//
//  RadioGroup.m
//  coffeeMachine
//
//  Created by Beifei on 6/4/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "RadioGroup.h"

@interface RadioGroup()

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, assign) float columnOffset;
@property (nonatomic, assign) float rowOffset;
@property (nonatomic, assign) float btnWidth;
@property (nonatomic, assign) float btnHeight;

@property (nonatomic, assign) NSInteger row;

@end

@implementation RadioGroup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initData];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initData];
}

- (void)initData
{
    _column = 1;
    _selectType = SelectType_CanBeNone;
    
    _columnOffset = 10;
    _rowOffset = 5;
    
    _btnHeight = 30;
    _btnWidth = (self.frame.size.width - _column * _columnOffset)/_column;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setUnselectedBg:(UIImage *)unselectedBg
{
    _unselectedBg = unselectedBg;
    
    _btnWidth = unselectedBg.size.width;
    _btnHeight = unselectedBg.size.height;
    
    if (_column>1) {
        _columnOffset = (self.frame.size.width - _btnWidth * _column)/(_column-1);
    }
    if (_row>1) {
        _rowOffset = (self.frame.size.height - _btnHeight * _row)/(_row-1);
    }
    
    [self setNeedsDisplay];
}

- (void)setUnselectedTextColor:(UIColor *)unselectedTextColor
{
    _unselectedTextColor = unselectedTextColor;
    for (int i = 0; i < [_buttonArray count]; i++) {
        
        UIButton *btn = [_buttonArray objectAtIndex:i];
        [btn setTitleColor:unselectedTextColor forState:UIControlStateNormal];
    }
}

- (void)setHighlightedBg:(UIImage *)highlightedBg
{
    _highlightedBg = highlightedBg;
    for (int i = 0; i < [_buttonArray count]; i++) {
        
        UIButton *btn = [_buttonArray objectAtIndex:i];
        [btn setBackgroundImage:highlightedBg forState:UIControlStateHighlighted];
    }
}

- (void)setHighlightedTextColor:(UIColor *)highlightedTextColor
{
    _highlightedTextColor = highlightedTextColor;
    for (int i = 0; i < [_buttonArray count]; i++) {
        
        UIButton *btn = [_buttonArray objectAtIndex:i];
        [btn setTitleColor:highlightedTextColor forState:UIControlStateHighlighted];
    }
}

- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    _row = [titleArray count]/_column;
    _btnHeight = (self.frame.size.height - _row *_rowOffset)/_row;
    
    _buttonArray = [NSMutableArray arrayWithCapacity:[titleArray count]];
    
    for (int i = 0; i<[titleArray count]; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
        
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setBackgroundImage:_highlightedBg forState:UIControlStateHighlighted];
        [btn setTitleColor:_highlightedTextColor forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonArray addObject:btn];
        [self addSubview:btn];
    }
    [self setNeedsDisplay];
}

- (void)setColumn:(NSInteger)column
{
    _column = column;
    _row = [_buttonArray count]/_column;
    
    if (_row == 0) {
        _row = 1;
    }
    
    if (_column>1) {
        _columnOffset = (self.frame.size.width - _btnWidth * _column)/(_column-1);
    }
    if (_row>1) {
        _rowOffset = (self.frame.size.height - _btnHeight * _row)/(_row-1);
    }
    
    [self setNeedsDisplay];
}

- (IBAction)select:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (btn == self.selectedButton) {
        if (_selectType == SelectType_CanBeNone) {
            [self unselectButton:btn];
            self.selectedButton = nil;
        }
    }
    else {
        [self unselectButton:self.selectedButton];
        [self selectButton:btn];
        self.selectedButton = btn;
    }
    
    if (self.delegate) {
        [self.delegate buttonSelected:self];
    }
}

- (void)selectButton:(UIButton *)btn
{
    [btn setBackgroundImage:_selectedBg forState:UIControlStateNormal];
    [btn setTitleColor:_selectedTextColor forState:UIControlStateNormal];
}

- (void)unselectButton:(UIButton *)btn
{
    [btn setBackgroundImage:_unselectedBg forState:UIControlStateNormal];
    [btn setTitleColor:_unselectedTextColor forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    for (int i = 0; i < [_buttonArray count]; i++) {
        
        float x = (i%_column)*(_btnWidth+_columnOffset);
        float y = (i/_column)*(_btnHeight+_rowOffset);
        CGRect frame = CGRectMake(x, y, _btnWidth, _btnHeight);
        
        UIButton *btn = [_buttonArray objectAtIndex:i];
        [btn setFrame:frame];
        
        if (_unselectedBg) {
            [btn setBackgroundImage:_unselectedBg forState:UIControlStateNormal];
        }
    }
}

#pragma mark - methods outside
- (NSInteger)selectedIndex
{
    if (self.selectedButton == nil) {
        return -1;
    }
    else {
        return [self.buttonArray indexOfObject:self.selectedButton];
    }
}

- (void)unselectAll
{
    [self unselectButton:self.selectedButton];
    self.selectedButton = nil;
}

@end
