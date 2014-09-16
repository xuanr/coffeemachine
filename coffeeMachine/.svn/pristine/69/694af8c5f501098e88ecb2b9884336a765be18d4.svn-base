//
//  MailBindViewController.m
//  coffeeMachine
//
//  Created by Beifei on 5/22/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "MailBindViewController.h"
#import "ImageLabelView.h"
#import "NSString+Util.h"
#import "SVProgressHUD.h"
#import "VerifyCodeButton.h"

@interface MailBindViewController ()

@property (weak, nonatomic) IBOutlet ImageLabelView *mailView;
@property (weak, nonatomic) IBOutlet ImageLabelView *verifyView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet VerifyCodeButton *verifyBtn;

@property (nonatomic, strong) UITextField *currentTextField;

@property (nonatomic, strong) NSOperation *modifyOperation;
@property (nonatomic, strong) NSOperation *verifyCodeOperation;

@end

@implementation MailBindViewController

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
    
    self.title = NSLocalizedString(@"Bind Mail", nil);
    
    [self initUI];
}

- (void)dealloc
{
    [self.modifyOperation cancel],self.modifyOperation = nil;
    [self.verifyCodeOperation cancel],self.verifyCodeOperation = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)initUI
{
    self.mailView.backgroundColor = [UIColor whiteColor];
    self.verifyView.backgroundColor = [UIColor whiteColor];
    
    self.mailView.textField.placeholder = NSLocalizedString(@"Input email account", nil);
    self.verifyView.textField.placeholder = NSLocalizedString(@"Input verify code", nil);
    
    self.mailView.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.mailView.textField.returnKeyType = UIReturnKeyNext;
    self.verifyView.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.mailView.icon setImage:[UIImage imageNamed:@"icon_email"]];
    [self.verifyView.icon setImage:[UIImage imageNamed:@"icon_verify"]];
    
    self.mailView.textField.delegate = self;
    self.verifyView.textField.delegate = self;
    
    self.submitBtn.enabled = NO;
    self.verifyBtn.enabled = NO;

    if (![self.text isEqual:[NSNull null]] && ![self.text isEqualToString:@""]) {
        self.mailView.textField.text = self.text;
    }
    
    [self.mailView addSeperatorLine];
    [self.verifyView addSeperatorLine];
    
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
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self checkVerifyBtn];
    [self checkSubmitBtnStatus];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.mailView.textField]) {
        
        if (![self.mailView.textField.text isEmpty] && ![self.mailView.textField.text checkEmailValid]) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"INVALID_Email", nil)];
        }
        [self checkVerifyBtn];
    }
    [self checkSubmitBtnStatus];
}

- (void)checkSubmitBtnStatus
{
    if ([self.mailView.textField.text checkEmailValid] && ![self.verifyView.textField.text isEmpty]) {
        self.submitBtn.enabled = YES;
    }
    else {
        self.submitBtn.enabled = NO;
    }
}

- (void)checkVerifyBtn
{
    if ([self.mailView.textField.text checkEmailValid]) {
        self.verifyBtn.enabled = YES;
    }
    else {
        self.verifyBtn.enabled = NO;
    }
}

#pragma mark - gesture 
- (IBAction)tap:(id)sender {
    [self.currentTextField resignFirstResponder];
    self.currentTextField = nil;
    [self checkVerifyBtn];
    [self checkSubmitBtnStatus];
}

#pragma mark - action
- (IBAction)submit:(id)sender {
    NSDictionary *dict = @{@"mail":[self.mailView.textField.text trim],@"verify":[self.verifyView.textField.text trim]};
    __weak MailBindViewController *vc = self;
    
    if (self.modifyOperation) {
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    self.modifyOperation = [HttpRequest modifyUserInfo:dict user:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token completionWithSuccess:^{
        [[UserInfo sharedInstance] updateUserInfoType:UserInfo_Mail value:[self.mailView.textField.text trim]];
        vc.modifyOperation = nil;
        [SVProgressHUD dismiss];
        [vc.navigationController popViewControllerAnimated:YES];
    } failure:^(int errorCode) {
        vc.modifyOperation = nil;
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (IBAction)verifyCode:(id)sender {
    __weak MailBindViewController *vc = self;
    
    if (self.verifyCodeOperation) {
        return;
    }
    
    self.verifyCodeOperation = [HttpRequest verifyCodeWithUser:[UserInfo sharedInstance].userId email:[self.mailView.textField.text trim] completionWithSuccess:^{
        [vc.verifyBtn startCountDown];
        vc.modifyOperation = nil;
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"VERIFY_CODE_MAIL", nil)];
    } failure:^(int errorCode) {
        vc.modifyOperation = nil;
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - notification
- (void)textFieldChanged:(NSNotification *)info
{
    if (self.currentTextField == self.mailView.textField) {
        [self checkVerifyBtn];
    }
    [self checkSubmitBtnStatus];
}

@end
