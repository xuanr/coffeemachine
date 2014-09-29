//
//  ViewController.m
//  test_3dRotate
//
//  Created by xuanr on 14-9-28.
//  Copyright (c) 2014年 hz. All rights reserved.
//

#import "ViewController.h"
#import "UIView+AnchorPoint.h"
#import "aaViewController.h"
#import "bbViewController.h"
#define MENUBTNTAG 100
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *targetView;
@property (strong, nonatomic) NSArray *viewControllers;
@property(nonatomic,assign) NSUInteger selectViewIndex;
@property(strong ,nonatomic)UIViewController *selectedViewController;
@end

@implementation ViewController
//- (IBAction)butIs_press:(id)sender {
//    [self transformForContentView:150 animation:YES];
//
//}
//- (IBAction)btn_close:(id)sender {
//    [self transformForContentView:0 animation:YES];
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    aaViewController *viewa = [[aaViewController alloc]init];
    bbViewController *viewb = [[bbViewController alloc]init];
    NSMutableArray * Allviews = [[NSMutableArray alloc]init];
    [Allviews addObject:viewa];
    [Allviews  addObject:viewb];
    self.viewControllers = Allviews ;
    _selectViewIndex = -1;
//    [self setSelectViewIndex:0];
//    _selectViewIndex = 0;
    UIButton *btn_1 = [[UIButton alloc]init];
    btn_1.tag = 0+MENUBTNTAG;
    btn_1.frame = CGRectMake(50, 200, 50, 50);
    btn_1.backgroundColor = [UIColor blackColor];
    [self.view addSubview:btn_1];
    [btn_1 addTarget:self action:@selector(menuChoice:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn_2 = [[UIButton alloc]init];
    btn_2.tag = 1+MENUBTNTAG;
    btn_2.frame = CGRectMake(50, 300, 50, 50);
    btn_2.backgroundColor = [UIColor blackColor];
    [self.view addSubview:btn_2];
    [btn_2 addTarget:self action:@selector(menuChoice:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setselectViewIndex:0];
   
    
    self.view.backgroundColor = [UIColor redColor];
    self.selectedViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.selectedViewController.view];
    [(CenterViewController*)_selectedViewController transformForContentView:0 animation:NO duration:0];

    
    // Do any additional setup after loading the view, typically from a nib.
}
-(IBAction)menuChoice:(id)sender
{
    NSLog(@"menuChoice");

    UIButton *button = (UIButton *)sender;
    
    [self setselectViewIndex:button.tag-MENUBTNTAG];
    [(CenterViewController*)self.selectedViewController setFull];
}
-(void)setselectViewIndex:(NSUInteger )selectViewIndex
{
    NSLog(@"setSelectViewIndex");
    NSLog(@"%d,%d",_selectViewIndex,selectViewIndex);
    if (_selectViewIndex==selectViewIndex) {
        return;
    }
    _selectViewIndex = selectViewIndex;
    [self setselectedViewController:[self.viewControllers objectAtIndex:(int)selectViewIndex]];
//    [self.view addSubview:_selectedViewController.view];

}
-(void)setselectedViewController:(UIViewController*)vc
{
    NSLog(@"setselectedViewController is called");
    UIViewController *oldVc = _selectedViewController;
    if (_selectedViewController!=vc) {
        [oldVc removeFromParentViewController];
//        vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        [self addChildViewController:vc];
//        [vc didMoveToParentViewController:self];
        [oldVc.view removeFromSuperview];
        _selectedViewController = vc;
        [self.view addSubview:vc.view];
        vc.view.frame = self.view.bounds;
        [(CenterViewController*)vc transformForContentView:150 animation:NO duration:0];



    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


@end
