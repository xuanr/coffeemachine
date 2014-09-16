//
//  AvatarImageView.m
//  coffeeMachine
//
//  Created by Beifei on 6/19/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "AvatarImageView.h"

@implementation AvatarImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.geometryFlipped = YES;
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    if (_image != image)
    {
        _image = image;
        [self setNeedsDisplay];
    }
}


- (CGPathRef)path
{
    return [[UIBezierPath bezierPathWithRoundedRect:self.bounds
                                       cornerRadius:CGRectGetWidth(self.bounds) / 2] CGPath];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGContextAddPath(context, [self path]);
    CGContextClip(context);
    
    if (self.image)
    {
        CGContextDrawImage(context, rect, self.image.CGImage);
    }
    CGContextRestoreGState(context);
}


@end
