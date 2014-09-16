//
//  LoginViewController.m
//  coffeeMachine
//
//  Created by Beifei on 5/19/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "LoginViewController.h"
#import "ImageLabelView.h"
#import "HttpRequest.h"
#import "NSString+Util.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet ImageLabelView *nameView;
@property (weak, nonatomic) IBOutlet ImageLabelView *passwordView;

@property (strong, nonatomic) UITextField *currentTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) NSOperation *loginOperation;

@end

@implementation LoginViewController

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
    [self.loginOperation cancel],self.loginOperation = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self restoreNavBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Login", nil);
    [self initUI];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 25, 25)];
    
    if ([[[self navigationController]viewControllers]count]==1) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = item;
    }
}

- (void)back:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)restoreNavBar
{
    if (IOS7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar_ios7"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.translucent = NO;
    }
    else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)initNavBar
{
    if (IOS7) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"whiteNavBar_ios7"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.translucent = YES;
    }
    else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"whiteNavBar"] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)initUI
{
//    [self initNavBar];
    
    self.nameView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.passwordView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    self.nameView.textField.placeholder = NSLocalizedString(@"Phone Number", nil);
    self.passwordView.textField.placeholder = NSLocalizedString(@"6~12 characters", nil);
    
    self.passwordView.textField.secureTextEntry = YES;
    self.nameView.textField.keyboardType = UIKeyboardTypePhonePad;
    self.passwordView.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordView.textField.returnKeyType = UIReturnKeyDone;
    
    [self.nameView.icon setImage:[UIImage imageNamed:@"icon_name"]];
    [self.passwordView.icon setImage:[UIImage imageNamed:@"icon_password"]];
    
    self.nameView.textField.delegate = self;
    self.passwordView.textField.delegate = self;
    
    self.loginBtn.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueToRegister"]) {
        RegisterViewController *vc = (RegisterViewController *) segue.destinationViewController;
        vc.delegate = self;
    }
}

#pragma makr - Register Delegate
- (void)registerSuccess
{
    [self.delegate loginSuccess:self];
}

#pragma mark - action
- (IBAction)login:(id)sender {
    __weak LoginViewController *vc = self;
    
    if (self.loginOperation) {
        return;
    }
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loggin...", nil)];
    self.loginOperation = [HttpRequest loginWithUser:[self.nameView.textField.text trim] password:[[self.passwordView.textField.text trim]md5] completionWithSuccess:^(NSString *token,NSString *userId){
        [SVProgressHUD dismiss];
        [[UserInfo sharedInstance]loginWithUserId:userId token:token];
        [UserInfo sharedInstance].mobile = [vc.nameView.textField.text trim];
        [vc.delegate loginSuccess:self];
        vc.loginOperation = nil;
    } failure:^(int errorCode){
        vc.loginOperation = nil;
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (IBAction)tap:(id)sender {
    [self.currentTextField resignFirstResponder];
    self.currentTextField = nil;
    [self checkLoginBtnStatus];
}

#pragma mark - text field delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self checkLoginBtnStatus];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.nameView.textField]) {
        
        if (![self.nameView.textField.text isEmpty] && ![self.nameView.textField.text checkPhoneValid]) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"INVALID_PHONE", nil)];
        }
    }
}

- (void)checkLoginBtnStatus
{
    if ([self.nameView.textField.text checkPhoneValid] && [self.passwordView.textField.text checkPasswordValid]) {
        [self enable:YES button:self.loginBtn];
    }
    else {
        [self enable:NO button:self.loginBtn];
    }
}

- (void)enable:(BOOL)enable button:(UIButton *)btn
{
    btn.enabled = enable;
    if (enable) {
        [btn setBackgroundColor:BrownColor];
    }
    else {
        [btn setBackgroundColor:DisabledColor];
    }
}

@end
