//
//  VerifyCodeButton.m
//  coffeeMachine
//
//  Created by Beifei on 6/13/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "VerifyCodeButton.h"

@interface VerifyCodeButton()

@property (nonatomic, assign) NSInteger countDown;
@property (nonatomic, assign) BOOL needsEnabled;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation VerifyCodeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initButton];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initButton];
}

- (void)initButton
{
    self.titleLabel.text = NSLocalizedString(@"获取验证码", nil);
}

- (void)startCountDown
{
    [super setEnabled:NO];
    self.countDown = 60;
    self.titleLabel.text = [NSString stringWithFormat:@"%ds %@",self.countDown--, NSLocalizedString(@"后重试", nil)];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeHint:) userInfo:nil repeats:YES];
}

- (void)setEnabled:(BOOL)enabled
{
    if (enabled) {
        if (self.timer) {
            self.needsEnabled = YES;
            return;
        }
    }
    [super setEnabled:enabled];
}

- (void)changeHint:(id)sender
{
    if (self.countDown == 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.titleLabel.text = NSLocalizedString(@"获取验证码", nil);
        if (_needsEnabled) {
            [super setEnabled:YES];
        }
        else {
            [super setEnabled:NO];
        }
    }
    else {
        self.titleLabel.text = [NSString stringWithFormat:@"%ds %@",self.countDown--, NSLocalizedString(@"后重试", nil)];
    }
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
