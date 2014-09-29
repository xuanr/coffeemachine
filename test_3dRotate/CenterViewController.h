//
//  CenterViewController.h
//  test_3dRotate
//
//  Created by xuanr on 14-9-28.
//  Copyright (c) 2014年 hz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterViewController : UIViewController
-(void)setFull;
- (void)transformForContentView:(CGFloat)distance animation:(BOOL)animation duration:(CGFloat) dura;
@end
