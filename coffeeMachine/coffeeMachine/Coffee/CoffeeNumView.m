//
//  CoffeeNumView.m
//  coffeeMachine
//
//  Created by xuanr on 14-6-27.
//  Copyright (c) 2014年 iChuansuo. All rights reserved.
//

#import "CoffeeNumView.h"

@implementation CoffeeNumView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setStatus:(NSNumber *)status
{
    _status = status;
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)reck
{
//    NSLog(@"draw Reck is called:%@",self.status);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor (context, 1.0, 1.0, 1.0, 1.0);
    //设置字体
    
    UIFont *wordfond = [UIFont systemFontOfSize: 15];
    //    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0f], NSFontAttributeName, nil];
    if ([self.status intValue] == 1) {
        [@"不足" drawInRect:CGRectMake(7, 20, 58, 20) withFont:wordfond];
        wordfond = [UIFont systemFontOfSize: 10];
        [@"摩卡: 0杯" drawInRect:CGRectMake(58, 9, 58, 15) withFont:wordfond];
        [@"拿铁: 0杯" drawInRect:CGRectMake(110, 9, 58, 15) withFont:wordfond];
        [@"卡布奇诺: 0杯" drawInRect:CGRectMake(58, 25, 70, 15) withFont:wordfond];
        [@"浓缩咖啡: 0杯" drawInRect:CGRectMake(58, 40, 70, 15) withFont:wordfond];
        self.status = [NSNumber numberWithInt:1];
        
    }else
    {
         UIFont *wordfond = [UIFont systemFontOfSize: 15];
    [@"不足" drawInRect:CGRectMake(17, 20, 58, 20) withFont:wordfond];
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
