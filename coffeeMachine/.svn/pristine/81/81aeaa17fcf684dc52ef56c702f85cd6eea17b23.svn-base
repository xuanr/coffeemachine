//
//  RegisterViewController.m
//  coffeeMachine
//
//  Created by Beifei on 5/19/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "RegisterViewController.h"
#import "HttpRequest.h"
#import "ImageLabelView.h"
#import "NSString+Util.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
#import "VerifyCodeButton.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet VerifyCodeButton *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@property (weak, nonatomic) IBOutlet ImageLabelView *nameView;
@property (weak, nonatomic) IBOutlet ImageLabelView *passwordView;
@property (weak, nonatomic) IBOutlet ImageLabelView *verifyView;

@property (strong, nonatomic) UITextField *currentTextField;

@property (nonatomic, assign) BOOL agreeStatus;

@property (nonatomic, strong) NSOperation *verifyCodeOperation;
@property (nonatomic, strong) NSOperation *registerOperation;

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Register", nil);
    
    [self initUI];
}

- (void)dealloc
{
    [self.verifyCodeOperation cancel],self.verifyCodeOperation = nil;
    [self.registerOperation cancel],self.registerOperation = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:self.nameView.textField];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self restoreNavBar];
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
    self.nameView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.passwordView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.verifyView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    self.nameView.textField.placeholder = NSLocalizedString(@"Phone Number", nil);
    self.passwordView.textField.placeholder = NSLocalizedString(@"6~12 characters", nil);
    self.verifyView.textField.placeholder = NSLocalizedString(@"Verify Code", nil);
    
    self.passwordView.textField.secureTextEntry = YES;
    self.nameView.textField.keyboardType = UIKeyboardTypePhonePad;
    self.passwordView.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.verifyView.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordView.textField.returnKeyType = UIReturnKeyNext;
    
    [self.nameView.icon setImage:[UIImage imageNamed:@"icon_name"]];
    [self.passwordView.icon setImage:[UIImage imageNamed:@"icon_password"]];
    [self.verifyView.icon setImage:[UIImage imageNamed:@"icon_code"]];
    
    self.nameView.textField.delegate = self;
    self.passwordView.textField.delegate = self;
    self.verifyView.textField.delegate = self;
    
    self.agreeStatus = NO;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
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

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.passwordView.textField]) {
        [self.verifyView.textField becomeFirstResponder];
        
        if (![self.passwordView.textField.text isEmpty]&&![self.passwordView.textField.text checkPasswordValid]) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"INVALID_PASSWORD", nil)];
        }
    }
    else {
        [textField resignFirstResponder];
    }
    
    [self checkSubmitStatus];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.nameView.textField]) {
        
        if (![self.nameView.textField.text isEmpty] && ![self.nameView.textField.text checkPhoneValid]) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"INVALID_PHONE", nil)];
        }
    }
    else {
        if ([textField isEqual:self.passwordView.textField]) {
            [self.verifyView.textField becomeFirstResponder];
            
            if (![self.passwordView.textField.text isEmpty]&&![self.passwordView.textField.text checkPasswordValid]) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"INVALID_PASSWORD", nil)];
            }
        }
    }
    [self checkVerifyBtnStatus];
}

- (void)textFieldChanged:(NSNotification *)info
{
    if (self.currentTextField == self.nameView.textField) {
        [self checkVerifyBtnStatus];
    }
    [self checkSubmitStatus];
}

#pragma mark - aciton
- (IBAction)verifyCode:(id)sender {
    if ([self.nameView.textField.text isEmpty]) {
        return;
    }
    
    if (self.verifyCodeOperation) {
        return;
    }
    __weak RegisterViewController *vc = self;
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    self.verifyCodeOperation = [HttpRequest verifyCodeWithUser:[self.nameView.textField.text trim] type:VerifyCodeType_Register completionWithSuccess:^{
        [vc.verifyCodeBtn startCountDown];
        vc.verifyCodeOperation = nil;
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"VERIFY_CODE_MOBILE", nil)];
    } failure:^(int errorCode){
        vc.verifyCodeOperation = nil;
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (IBAction)submit:(id)sender {
    
    if (self.registerOperation) {
        return;
    }
    
    __weak RegisterViewController *vc = self;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    self.registerOperation = [HttpRequest registerRequestWithUser:[self.nameView.textField.text trim] password:[[self.passwordView.textField.text trim]md5] verifyCode:[self.verifyView.textField.text trim] completionWithSuccess:^(NSString *token, NSString *userId){
        [[UserInfo sharedInstance]registerWithUserId:userId token:token];
        [UserInfo sharedInstance].mobile = [vc.nameView.textField.text trim];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Register Sucess", nil)];
        [vc.delegate registerSuccess];
    } failure:^(int errorCode){
        vc.registerOperation = nil;
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (IBAction)tap:(id)sender {
    
    if ([self.currentTextField isEqual:self.nameView.textField]) {
        
        if (![self.nameView.textField.text isEmpty] && ![self.nameView.textField.text checkPhoneValid]) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"INVALID_PHONE", nil)];
        }
    }
    
    [self.currentTextField resignFirstResponder];
    self.currentTextField = nil;
    [self checkSubmitStatus];
    [self checkVerifyBtnStatus];
}

- (IBAction)agree:(id)sender {
    self.agreeStatus = !self.agreeStatus;
    
    if (self.agreeStatus) {
        [self.agreeButton setImage:[UIImage imageNamed:@"btn_rules_pressed"] forState:UIControlStateNormal];
    }
    else{
        [self.agreeButton setImage:[UIImage imageNamed:@"btn_rules"] forState:UIControlStateNormal];
    }
    
    [self checkSubmitStatus];
}

- (void)checkSubmitStatus
{
    if (self.agreeStatus && ![self.verifyView.textField.text isEmpty] && [self.nameView.textField.text checkPhoneValid] && [self.passwordView.textField.text checkPasswordValid]) {
        [self enable:YES button:self.submitBtn];
    }
    else {
        [self enable:NO button:self.submitBtn];
    }
}

- (void)checkVerifyBtnStatus
{
    if ([self.nameView.textField.text checkPhoneValid]) {
        [self enable:YES button:self.verifyCodeBtn];
    }
    else {
        [self enable:NO button:self.verifyCodeBtn];
    }
}

- (void)enable:(BOOL)enable button:(UIButton *)btn
{
    btn.enabled = enable;
    if (enable) {
        [btn setBackgroundColor:TransparentBrownColor];
    }
    else {
        [btn setBackgroundColor:DisabledColor];
    }
}

@end
