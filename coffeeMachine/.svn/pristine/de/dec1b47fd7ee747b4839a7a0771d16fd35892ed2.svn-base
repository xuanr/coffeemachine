//
//  CoffeeShakeGuideView.m
//  coffeeMachine
//
//  Created by Beifei on 7/10/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "CoffeeShakeGuideView.h"

@interface CoffeeShakeGuideView()

@property (nonatomic, strong) UIImageView *leftCoffee;
@property (nonatomic, strong) UIImageView *rightCoffee;

@end

@implementation CoffeeShakeGuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithNum:(NSInteger)num
{
    if (self = [super initWithNum:num]) {
        
        self.rightCoffee = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guide2-coffee1"]];
        [self.rightCoffee setFrame:CGRectMake(241, 98, 48, 58)];
        self.rightCoffee.alpha = 0;
        self.leftCoffee = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guide2-coffee2"]];
        [self.leftCoffee setFrame:CGRectMake(178, 98, 48, 58)];
        self.leftCoffee.alpha = 0;
        
        [self addSubview:self.leftCoffee];
        [self addSubview:self.rightCoffee];
    }
    return self;
}

- (void)beginAnimate
{
    __weak CoffeeShakeGuideView *view = self;
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.labelView.alpha = 1.0;
        
        [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            view.leftCoffee.alpha = 1.0;
            view.rightCoffee.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                view.leftCoffee.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI/4), CGAffineTransformMakeScale(1.0, 1.0));
                view.rightCoffee.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(-M_PI/4), CGAffineTransformMakeScale(1.0, 1.0));
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    
                    view.leftCoffee.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(0), CGAffineTransformMakeScale(1.0, 1.0));
                    view.rightCoffee.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(0), CGAffineTransformMakeScale(1.0, 1.0));
                } completion:^(BOOL finished) {
                }];
            }];
            
        }];

    } completion:^(BOOL finished) {
    }];
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
