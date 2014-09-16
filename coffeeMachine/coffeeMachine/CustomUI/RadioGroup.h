//
//  RadioGroup.h
//  coffeeMachine
//
//  Created by Beifei on 6/4/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    SelectType_CanBeNone,
    SelectType_AtLeastOne
}SelectType;

@class RadioGroup;

@protocol RadioGroupDelegate <NSObject>

- (void)buttonSelected:(RadioGroup *)group;

@end

@interface RadioGroup : UIView

@property (nonatomic, weak) id<RadioGroupDelegate> delegate;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) SelectType selectType;

@property (nonatomic, strong) UIImage *selectedBg;
@property (nonatomic, strong) UIImage *unselectedBg;
@property (nonatomic, strong) UIImage *highlightedBg;

@property (nonatomic, strong) UIColor *selectedBgColor;
@property (nonatomic, strong) UIColor *unselectedBgColor;
@property (nonatomic, strong) UIColor *highlightedColor;

@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *unselectedTextColor;
@property (nonatomic, strong) UIColor *highlightedTextColor;

- (NSInteger)selectedIndex;
- (void)unselectAll;

@end
