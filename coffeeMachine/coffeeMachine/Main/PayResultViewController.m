//
//  PayResultViewController.m
//  coffeeMachine
//
//  Created by Beifei on 6/26/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "PayResultViewController.h"
#import "XHDrawerController.h"
#import "MainViewController.h"
#import "SlideNavigationViewController.h"
#import "AppDelegate.h"
#import "OrderTableViewController.h"
#import "AccountViewController.h"

@interface PayResultViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *resultImage;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation PayResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithType:(ResultType)type status:(BOOL)status
{
    self = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"PayResultViewController"];
    if (self) {
        self.type = type;
        self.status = status;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Notification", nil);
    
    if (self.type == ResultType_Recharge) {
        self.detailLabel.hidden = YES;
        [self.nextBtn setTitle:NSLocalizedString(@"Continue Recharge", nil) forState:UIControlStateNormal];
        if (self.status) {
            self.resultLabel.text = NSLocalizedString(@"Recharge Success!", nil);
        }
        else {
            self.resultLabel.text = NSLocalizedString(@"Recharge Fail", nil);
        }
    }
    
    if (!self.status) {
        [self.resultImage setImage:[UIImage imageNamed:@"icon_notif_fail"]];
        if (self.type == ResultType_Pay) {
            self.resultLabel.text = NSLocalizedString(@"Pay Fail", nil);
            self.detailLabel.hidden = YES;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)next:(id)sender {
    if (self.type == ResultType_Pay) {
        OrderTableViewController *vc = [[UIStoryboard storyboardWithName:@"UserStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"OrderTableViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        AccountViewController *vc = [[UIStoryboard storyboardWithName:@"UserStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"AccountViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
