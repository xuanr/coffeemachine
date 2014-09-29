//
//  CenterViewController.m
//  test_3dRotate
//
//  Created by xuanr on 14-9-28.
//  Copyright (c) 2014年 hz. All rights reserved.
//

#import "CenterViewController.h"
#import "ViewController.h"
#import "UIView+AnchorPoint.h"

@interface CenterViewController ()

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    UIButton * btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(0, 0, 100, 100);
    btn.backgroundColor  = [UIColor orangeColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view.
}
-(IBAction)back:(id)sender
{
    [self transformForContentView:150 animation:YES duration:0.3];
    
}
-(void)setFull
{
    NSLog(@"setFull");
    [self transformForContentView:0 animation:NO duration:0.3];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)transformForContentView:(CGFloat)distance animation:(BOOL)animation duration:(CGFloat) dura{
    CGFloat distanceThreshold = 150;
    CGFloat coverAngle = -55.0 / 180.0 * M_PI;
    CGFloat perspective = -1.0/1150;  // fixed
    
    CGFloat coverScale = 0.5;       // fixed
    CGFloat percentage = fabsf(distance)/distanceThreshold;
    
    [self.view setAnchorPoint:CGPointMake(0, 0.5)];
    //    NSLog(@"percentage : %f",percentage);
    //    NSLog(@"%d",NO);
    
    [UIView animateWithDuration:dura animations:^{
        self.view.layer.transform = [self
                                           transform3DWithRotation:percentage * coverAngle
                                           scale:(1 - percentage) * (1 - coverScale) + coverScale
                                           translationX:distance
                                           perspective:perspective
                                           ];
    }];
    
    
}
- (CATransform3D)transform3DWithRotation:(CGFloat)angle
                                   scale:(CGFloat)scale
                            translationX:(CGFloat)tranlationX
                             perspective:(CGFloat)perspective {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = perspective;
    transform = CATransform3DTranslate(transform, tranlationX , 0, 0);
    transform = CATransform3DScale(transform, scale, scale, 1.0);
    transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0);
    
    return transform;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
