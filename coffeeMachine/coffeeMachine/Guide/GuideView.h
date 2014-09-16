//
//  GuideView.h
//  coffeeMachine
//
//  Created by Beifei on 7/10/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNumberOfPages 4

@protocol GuideViewDelegate <NSObject>

@optional
- (void)finishedGuideView;

@end

@interface GuideView : UIImageView

@property (nonatomic, strong) UIImageView *labelView;
@property (nonatomic, strong) UIImageView *picView;

@property (nonatomic, weak) id<GuideViewDelegate> delegate;

- (id)initWithNum:(NSInteger)num;
- (void)beginAnimate;

@end
