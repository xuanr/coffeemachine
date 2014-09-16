//
//  SlideNavigationViewController.m
//  coffeeMachine
//
//  Created by Beifei on 5/16/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "SlideNavigationViewController.h"
#import "XHDrawerController.h"
#import "CenterTableViewController.h"
#import "SettingViewController.h"

#define ButtonNum 6
#define ButonnTagStart 100
#define ButtonLeft1Offset 23
#define ButtonWidth 92
#define ButtonHeight 92
#define ButtonLeft2Offset 137
#define ButtonTopOffset (IPHONE3_5INCH?130:175)
#define ButtonRowBlank 23

@interface SlideNavigationViewController ()

@end

@implementation SlideNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
        [self initSlideButtons];
        [self addSettingButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init
- (void)initSlideButtons
{
    NSArray *imgArray = [NSArray arrayWithObjects:@"btn_main", @"btn_location", @"btn_user", @"btn_culture", @"btn_nearby", @"btn_setting",nil];
    NSArray *imgPressedArray = [NSArray arrayWithObjects:@"btn_main_pressed", @"btn_location_pressed", @"btn_user_pressed", @"btn_culture_pressed", @"btn_nearby_pressed", @"btn_setting_pressed",nil];
    
    for (int num = 0; num < 4; num++) {
        UIButton *btn = [[UIButton alloc]init];
        if (num % 2 ==0 ) {
            [btn setFrame:CGRectMake(ButtonLeft1Offset, ButtonTopOffset + (num/2)*(ButtonRowBlank+ButtonHeight), ButtonWidth, ButtonHeight)];
        }
        else {
            [btn setFrame:CGRectMake(ButtonLeft2Offset, ButtonTopOffset + (num/2)*(ButtonRowBlank+ButtonHeight), ButtonWidth, ButtonHeight)];
        }
        btn.tag = ButonnTagStart+num;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setImage:[UIImage imageNamed:imgArray[num]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgPressedArray[num]] forState:UIControlStateHighlighted];
        [self.view addSubview:btn];
    }
}

- (void)addSettingButton
{
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
    
    [settingBtn setImage:[UIImage imageNamed:@"btn_small_setting"] forState:UIControlStateNormal];
    [settingBtn setImage:[UIImage imageNamed:@"btn_small_setting_pressed"] forState:UIControlStateHighlighted];
    
    if (IPHONE3_5INCH) {
        [settingBtn setFrame:CGRectMake(20, 430, 25, 25)];
    }
    else {
        [settingBtn setFrame:CGRectMake(20, 528, 25, 25)];
    }
    [self.view addSubview:settingBtn];
}

#pragma mark - action
- (IBAction)setting:(id)sender
{
    SettingViewController *vc = [[UIStoryboard storyboardWithName:@"SettingStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"SettingViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)btnClicked:(id)sender
{
    NSArray *classArr = [NSArray arrayWithObjects:@"MainViewController", @"CoffeeViewController", @"UserViewController", @"CultureViewController", @"NearbyViewController", @"SettingViewController", nil];
    NSArray *storyArr = [NSArray arrayWithObjects:@"MainStoryboard", @"CoffeeStoryboard", @"UserStoryboard", @"CultureStoryboard", @"NearbyStoryboard", @"SettingStoryboard", nil];
    
    UIButton *btn = (UIButton *)sender;
    long idx = btn.tag - ButonnTagStart;
    
    NSString *className = [classArr objectAtIndex:idx];
    NSString *storyName = [storyArr objectAtIndex:idx];
    
    CenterTableViewController *vc = [[UIStoryboard storyboardWithName:storyName bundle:nil]instantiateViewControllerWithIdentifier:className];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    self.drawerController.centerViewController = navigationController;
    [self.drawerController closeDrawerAnimated:YES completion:nil];
}

@end
