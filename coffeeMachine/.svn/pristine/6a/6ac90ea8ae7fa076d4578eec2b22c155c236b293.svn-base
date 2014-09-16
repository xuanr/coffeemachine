//
//  ForgetPasswordViewController.m
//  coffeeMachine
//
//  Created by xuanr on 14-5-29.
//  Copyright (c) 2014年 iChuansuo. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ImageLabelView.h"
#import "HttpRequest.h"
#import "NSString+Util.h"
#import "SVProgressHUD.h"
#import "RetrivePasswordViewController.h"
#import "VerifyCodeButton.h"

@interface ForgetPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *mailmethod;
@property (weak, nonatomic) IBOutlet UIButton *phonemethod;
@property (weak, nonatomic) IBOutlet ImageLabelView *Emailtext;
@property (weak, nonatomic) IBOutlet ImageLabelView *Phonetext;
@property (weak, nonatomic) IBOutlet ImageLabelView *VerifyCodetext;
@property (strong, nonatomic) UITextField *currentTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet VerifyCodeButton *VerifyCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *fengxian;
@property (strong) NSString *VerifyCode;
@property (strong,nonatomic)UITapGestureRecognizer *tapgesture;

@property (strong, nonatomic) NSOperation *verifyCodeOperation;
@property (strong, nonatomic) NSOperation *resetOperation;

@end

@implementation ForgetPasswordViewController
int flag_ForgetPasswordViewController = 1;


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
    [self.verifyCodeOperation cancel],self.verifyCodeOperation = nil;
    [self.resetOperation cancel],self.resetOperation = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.title = NSLocalizedString(@"忘记密码", nil);
    self.VerifyCodeButton.enabled = NO;
    self.submitButton.enabled = NO;

    self.tapgesture = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                       action:@selector(tap:)]; /* The number of fingers that must be on the screen */
    self.tapgesture.numberOfTouchesRequired = 1;
    /* The total number of taps to be performed before the
     gesture is recognized */
    self.tapgesture.numberOfTapsRequired = 1;
    /* Add this gesture recognizer to our view */
    [self.view addGestureRecognizer:self.tapgesture];
    [self initUI];
       
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)initUI
{
    self.Emailtext.backgroundColor = [UIColor whiteColor];
    self.Emailtext.textField.placeholder = NSLocalizedString(@"邮箱地址", nil);
    self.Emailtext.textField.keyboardType = UIKeyboardTypePhonePad;
    [self.Emailtext.icon setImage:[UIImage imageNamed:@"icon_user"]];
    
    self.Emailtext.textField.delegate = self;
    
    self.Phonetext.backgroundColor = [UIColor whiteColor];
    self.Phonetext.textField.placeholder = NSLocalizedString(@"Phone Number", nil);
    self.Phonetext.textField.keyboardType = UIKeyboardTypePhonePad;
    [self.Phonetext.icon setImage:[UIImage imageNamed:@"icon_user"]];
    self.Phonetext.textField.delegate = self;
    
    self.VerifyCodetext.backgroundColor = [UIColor whiteColor];
    self.VerifyCodetext.textField.placeholder = NSLocalizedString(@"Verify Code", nil);
    self.VerifyCodetext.textField.keyboardType = UIKeyboardTypePhonePad;
    [self.VerifyCodetext.icon setImage:[UIImage imageNamed:@"icon_verify"]];
    self.VerifyCodetext.textField.delegate = self;
    
    [self.VerifyCodeButton setBackgroundImage:[UIImage imageNamed:@"btn_verify"] forState:UIControlStateNormal];
    self.fengxian.backgroundColor = BrownColor;
    
    [self.Emailtext addSeperatorLine];
    [self.Phonetext addSeperatorLine];
    
    [self updateUI];
    
}
-(void) updateUI
{
    
    if (flag_ForgetPasswordViewController == 1) {
        
        self.submitButton.frame = CGRectMake(0, 104, 320, 45);
        
        self.mailmethod.backgroundColor = BrownColor;
        [self.mailmethod setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.phonemethod.backgroundColor = [UIColor whiteColor];
        
        
        [self.phonemethod setTitleColor:BrownColor forState:UIControlStateNormal];
        
        self.Phonetext.hidden = YES;
        self.VerifyCodetext.hidden = YES;
        self.VerifyCodeButton.hidden = YES;
        self.Emailtext.hidden = NO;
        
        
        
    }else
    {
        CGRect frame = self.submitButton.frame;
        frame.origin.y = 159;
        [self.submitButton setFrame:frame];
        self.submitButton.frame = CGRectMake(0, 159, 320, 45);
        self.Phonetext.frame = CGRectMake(0, 49, 320, 55);
        self.VerifyCodetext.frame = CGRectMake(0, 104, 206, 55);
        self.VerifyCodeButton.frame = CGRectMake(206, 104, 114, 55);
        
        self.mailmethod.backgroundColor = [UIColor whiteColor];
        [self.mailmethod setTitleColor:BrownColor forState:UIControlStateNormal];
        
        self.phonemethod.backgroundColor = BrownColor;
        [self.phonemethod setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        self.Phonetext.hidden = NO;
        self.VerifyCodetext.hidden = NO;
        self.VerifyCodeButton.hidden = NO;
        self.Emailtext.hidden = YES;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - action
- (IBAction)mailbtn:(id)sender {
    flag_ForgetPasswordViewController = 1;
    [self updateUI];
}
- (IBAction)phonebtn:(id)sender {
    flag_ForgetPasswordViewController = 0;
    [self updateUI];
    
}
- (IBAction)GetVerifyCode:(id)sender {
    
    if (self.verifyCodeOperation) {
        return;
    }
    
    __weak ForgetPasswordViewController *vc = self;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    if ([self.Phonetext.textField.text checkPhoneValid]) {
        self.verifyCodeOperation = [HttpRequest verifyCodeWithUser:self.Phonetext.textField.text type:3 completionWithSuccess:^(NSDictionary *dis){
            [vc.VerifyCodeButton startCountDown];
            
            vc.verifyCodeOperation = nil;
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"VERIFY_CODE_MOBILE", nil)];
        }failure:^(int errorCode)
        {
            vc.verifyCodeOperation = nil;
            NSString *msg = [HttpRequest errorMsg:errorCode];
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"INVALID_PHONE", nil)];
    }
}

- (IBAction)Sutmit_btn_isPress:(id)sender {
    NSLog(@"submitIsPress is called");
    if (flag_ForgetPasswordViewController == 1) {
       
        NSString *user = self.Emailtext.textField.text;
        
        if (self.resetOperation) {
            return;
        }
        
        __weak ForgetPasswordViewController *vc = self;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        self.resetOperation = [HttpRequest MailRestPassword:user completionWithSuccess:^(NSDictionary * dis){
            
            vc.verifyCodeOperation = nil;
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"RESET_PASSWORD_MAIL", nil)];
        }failure:^(int errorCode){
           vc.verifyCodeOperation = nil;
           NSString *msg = [HttpRequest errorMsg:errorCode];
           [SVProgressHUD showErrorWithStatus:msg];
         }];
    }
}
#pragma deligate of textfiled

#pragma mark - delegate of segue
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"pushNewPassword"]) {
        if (flag_ForgetPasswordViewController == 0 && [self.Phonetext.textField.text checkPhoneValid]&& self.VerifyCodetext.textField.text.length != 0) {
            return YES;
        }
    }
    return NO;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushNewPassword"]) {
        RetrivePasswordViewController *nextcontroller = segue.destinationViewController;
        [nextcontroller setVerifyCode:self.VerifyCodetext.textField.text];
        [nextcontroller setUserId:self.Phonetext.textField.text];
    }
}

#pragma mark - delegate of textfield
- (IBAction)tap:(id)sender {
    NSLog(@"tap is called");
    [self.currentTextField resignFirstResponder];
    self.currentTextField = nil;
    [self checkLoginBtnStatus];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    NSLog(@"textFieldDidBeginEditing is called");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn is called");
    [textField resignFirstResponder];
    [self checkLoginBtnStatus];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing is called");
    if ([textField isEqual:self.Phonetext.textField]) {
        
        if (![self.Phonetext.textField.text isEmpty] && ![self.Phonetext.textField.text checkPhoneValid]) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"INVALID_PHONE", nil)];
        }
    }
    if ([textField isEqual:self.Emailtext.textField]) {
        if (![self.Emailtext.textField.text checkPhoneValid]&&self.Emailtext.textField.text.length) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"INVALID_PHONE", nil)];
        }
    }
     [textField resignFirstResponder];
    [self checkLoginBtnStatus];
}

#pragma mark - notification
- (void)textFieldChanged:(NSNotification *)info
{
    [self checkLoginBtnStatus];
}

- (void)checkLoginBtnStatus
{
    if (flag_ForgetPasswordViewController == 1) {
        if ([self.Emailtext.textField.text checkPhoneValid]) {
            [self enable:YES button:self.submitButton];
        }else{
            [self enable:NO button:self.submitButton];
        }
    }else{
        
        
        if ([self.Phonetext.textField.text checkPhoneValid] && self.VerifyCodetext.textField.text.length) {
            
            [self enable:YES button:self.submitButton];
        }
        else {
            [self enable:NO button:self.submitButton];
        }
        
        if ([self.Phonetext.textField.text checkPhoneValid]) {
            [self enable:YES button:self.VerifyCodeButton];
        }else
        {
            [self enable:NO button:self.VerifyCodeButton];
        }
    }
}

- (void)enable:(BOOL)enable button:(UIButton *)btn
{
    btn.enabled = enable;

}


@end
