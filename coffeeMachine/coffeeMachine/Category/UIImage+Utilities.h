//
//  UIImage+Utilities.h
//  yixin_iphone
//
//  Created by zqf on 13-1-18.
//  Copyright (c) 2013年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)
- (UIImage *)scaleWithMaxPixels: (CGFloat)maxPixels;

- (UIImage *)scaleToSize:(CGSize)newSize;

- (UIImage *)thumbnailOfSize:(CGSize)size;

- (UIImage *)makeImageRounded;

- (UIImage *)fixOrientation;

/// 不指定resizableImageWithCapInsets第2拉伸参数的时候，用的是平铺模式遇到大图片的拉伸时GPU卡爆，所以构造了本方法
- (UIImage *)resizableImageWithCapInsetsForStretch:(UIEdgeInsets)capInsets;


@end

