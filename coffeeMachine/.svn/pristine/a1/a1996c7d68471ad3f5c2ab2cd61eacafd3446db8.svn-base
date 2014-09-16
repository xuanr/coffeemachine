//
//  UserViewController.m
//  coffeeMachine
//
//  Created by Beifei on 5/19/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "UserViewController.h"
#import "RegisterViewController.h"
#import "ActivityViewController.h"
#import "AccountViewController.h"
#import "OrderTableViewController.h"
#import "CartTableViewController.h"
#import "UserTableViewCell.h"
#import "LoginViewController.h"
#import "UserInfoTableViewController.h"
#import "UIImage+Utilities.h"
#import "PictureDownloadManager.h"

#define pushActivity @"activityPushViewController"
#define pushAccount @"accountPushViewController"
#define pushOrder @"orderPushViewController"
#define pushCart @"cartPushViewController"

@interface UserViewController ()

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (nonatomic, assign) BOOL logined;

@property (nonatomic, strong) NSOperation *logoutOperation;
@property (nonatomic, strong) NSOperation *avatarOperation;

@end

@implementation UserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [self.logoutOperation cancel],self.logoutOperation = nil;
    [self.avatarOperation cancel],self.avatarOperation = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkAvatar];
};

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Personal", nil);
    
    [self initUI];
}

- (void)initUI
{
    self.logined = [[UserInfo sharedInstance]isLogin];
    
    if (IPHONE3_5INCH) {
        self.tableView.scrollEnabled = YES;
        self.tableView.showsVerticalScrollIndicator = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkAvatar
{
    if (![UserInfo sharedInstance].isLogin) {
        return;
    }
    if ([UserInfo sharedInstance].middleAvatar!=nil) {
        [self.iconBtn setImage:[[UserInfo sharedInstance].middleAvatar makeImageRounded] forState:UIControlStateNormal];
    }
    else {
        if (self.avatarOperation) {
            return;
        }
        
        __weak UserViewController *vc = self;
        self.avatarOperation = [HttpRequest avatarWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token offset:0 size:AvatarSize_Middle completionWithSuccess:^(NSString *url){
            
            UIImage *img = [[PictureDownloadManager sharedManager]pictureOfUrl:url];
            if (img) {
                [[UserInfo sharedInstance]setMiddleAvatar:img];
                [vc.iconBtn setImage:[img makeImageRounded] forState:UIControlStateNormal];
            }
            else {
                [[NSNotificationCenter defaultCenter]addObserverForName:PictureDownloadFinishedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                    NSDictionary *info = [note userInfo];
                    UIImage *img = [info objectForKey:url];
                    [[UserInfo sharedInstance]setMiddleAvatar:img];
                    [vc.iconBtn setImage:[img makeImageRounded] forState:UIControlStateNormal];
                }];
            }
            
            vc.avatarOperation = nil;
        } failure:^(int errorCode) {
            vc.avatarOperation = nil;
        }];
    }
}

#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (RETINA4INCH) {
        return 82;
    }
    else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [NSArray arrayWithObjects:@"accountCell", @"orderCell", @"cartCell", @"favCell",nil];
    NSString *identifier = [arr objectAtIndex:indexPath.row];
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UserTableViewCell alloc]init];
    }
    
    NSArray *labelArr = [NSArray arrayWithObjects:NSLocalizedString(@"Account", nil), NSLocalizedString(@"My Oder", nil), NSLocalizedString(@"Cart", nil), NSLocalizedString(@"Favorite", nil),nil];
    cell.label.text = [labelArr objectAtIndex:indexPath.row];
    [cell.label sizeToFit];
    
    NSArray *imgArr = [NSArray arrayWithObjects:@"icon_account", @"icon_order", @"icon_cart", @"icon_favorite",nil];
    
    cell.icon.image = [UIImage imageNamed:imgArr[indexPath.row]];
    [cell setNeedsDisplay];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}*/

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([UserInfo sharedInstance].isLogin) {
        return YES;
    }
    else
    {
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;;
    }
}

#pragma mark - action
- (IBAction)user:(id)sender {
    if (self.logined) {
        UserInfoTableViewController *vc = [[UIStoryboard storyboardWithName:@"UserInfoStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)logout:(id)sender
{
    NSString *user = [UserInfo sharedInstance].userId;
    NSString *token = [UserInfo sharedInstance].token;
    
    if (user!=nil && token!=nil) {
        
        if (self.logoutOperation) {
            return;
        }
        
        __weak UserViewController *vc = self;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        self.logoutOperation = [HttpRequest logoutWithUser:user token:token completionWithSuccess:^{
            [[UserInfo sharedInstance]logout];
            vc.logined = NO;
            [vc.iconBtn setImage:[UIImage imageNamed:@"icon_default_user"] forState:UIControlStateNormal];
            vc.logoutOperation = nil;
            [SVProgressHUD dismiss];
        } failure:^(int errorCode) {
            
            if (errorCode == 603) {
                [[UserInfo sharedInstance]logout];
                vc.logined = NO;
                [vc.iconBtn setImage:[UIImage imageNamed:@"icon_default_user"] forState:UIControlStateNormal];
                vc.logoutOperation = nil;
                [SVProgressHUD dismiss];
                
                return;
            }
            
            vc.logoutOperation = nil;
            NSString *msg = [HttpRequest errorMsg:errorCode];
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
    else {
        [[UserInfo sharedInstance]logout];
        self.logined = NO;
    }
}

#pragma mark - login/out
- (void)setLogined:(BOOL)logined
{
    _logined = logined;
    [self refreshRightBarBtn];
}

- (void)refreshRightBarBtn
{
    if (self.logined) {
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout", @"") style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
        [btn setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor]} forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = btn;
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - login delegate
- (void)loginSuccess:(id)sender
{
    self.logined = YES;
    [self.navigationController popToViewController:self animated:YES];
}

@end
