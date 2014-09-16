//
//  GuideView.m
//  coffeeMachine
//
//  Created by Beifei on 7/10/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "GuideView.h"

@interface GuideView()

@property (assign, nonatomic) NSInteger num;

@end

@implementation GuideView

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
    self.num = num;
    if (self = [self init]) {
        [self setImage:[UIImage imageNamed:[NSString stringWithFormat:@"guide%d.png",num]]];
        self.contentMode = UIViewContentModeScaleToFill;
        
        self.labelView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"guide%d-text",num]]];
        self.labelView.alpha = 0;
        self.picView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"guide%d-pic",num]]];
        self.picView.alpha = 0;
        
        [self addSubview:self.labelView];
        [self addSubview:self.picView];
    }
    return self;
}

- (void)beginAnimate
{
    __weak GuideView *view = self;
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.labelView.alpha = 1.0;
        
        [UIView animateWithDuration:1.5 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            view.picView.alpha = 1.0;
        } completion:^(BOOL finished) {
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
