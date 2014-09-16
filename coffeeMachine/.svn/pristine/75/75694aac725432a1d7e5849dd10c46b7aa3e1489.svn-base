//
//  RetrivePasswordViewController.m
//  coffeeMachine
//
//  Created by xuanr on 14-5-30.
//  Copyright (c) 2014年 iChuansuo. All rights reserved.
//

#import "RetrivePasswordViewController.h"
#import "ImageLabelView.h"
#import "HttpRequest.h"
#import "NSString+Util.h"
#import "SVProgressHUD.h"

@interface RetrivePasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *NewPassword_1;
@property (weak, nonatomic) IBOutlet UITextField *NewPassword_2;
@property (strong, nonatomic) UITapGestureRecognizer* tapgreture;
@property (strong, nonatomic) UITextField *currentTextField;
@property (weak, nonatomic) IBOutlet UIButton *submit_btn;
@property (strong, nonatomic)NSString *VerifyCode;
@property (strong, nonatomic)NSString *UserId;

@property (nonatomic, strong) NSOperation *resetOperation;

@end

@implementation RetrivePasswordViewController
int success_flag = 0;
-(void)setVerifyCode:(NSString *)VerifyCode
{
    _VerifyCode = VerifyCode;
    NSLog(@"verifyCode from retrivepassword %@",VerifyCode);
}
-(void)setUserId:(NSString *)UserId
{
    _UserId = UserId;
    NSLog(@"UserId from retrivepassword %@",UserId);
}
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
    [self.resetOperation cancel],self.resetOperation = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"找回密码";
    // Do any additional setup after loading the view.
    self.tapgreture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    self.tapgreture.numberOfTouchesRequired = 1;
    self.tapgreture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.tapgreture];
    self.submit_btn.enabled = NO;
    [self initUI];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    self.NewPassword_1.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.NewPassword_1.placeholder = NSLocalizedString(@"New Password", nil);
    self.NewPassword_1.secureTextEntry = YES;
    self.NewPassword_1.delegate = self;

    self.NewPassword_2.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.NewPassword_2.placeholder = NSLocalizedString(@"New Password again", nil);
    self.NewPassword_2.secureTextEntry = YES;
    self.NewPassword_2.delegate = self;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.NewPassword_1.frame.size.height-0.5, 320, 0.5)];
    line.backgroundColor = SeperatorColor;
    [self.view addSubview:line];
}
#pragma marj - delegate of textfield
- (IBAction)tap:(id)sender {
    NSLog(@" tap is called");
    [self.currentTextField resignFirstResponder];
    self.currentTextField = nil;
    [self checkLoginBtnStatus];
}

#pragma mark - text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing is called");
    self.currentTextField = textField;
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
    if (textField == self.NewPassword_1) {
        if (![self.NewPassword_1.text checkPasswordValid]) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"INVALID_PASSWORD", nil)];
        }
    }else
    {
        if (![self.NewPassword_1.text isEqualToString:self.NewPassword_2.text]&&self.NewPassword_1.text.length&&self.NewPassword_2.text.length) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"TWO PASSWORD NOT SAME", nil)];
    }
    }
}
//    if (self.NewPassword_1.text.length&&self.NewPassword_2.text.length) {
//        if (![self.NewPassword_1.text isEqualToString:self.NewPassword_2.text]) {
//            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"TWO PASSWORD NOT SAME", nil)];
//        }else
//        {
//            if (![self.NewPassword_1.text checkPasswordValid] ) {
//                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"INVALID_PASSWORD", nil)];
//            }
//        }
//        
//    }



- (void)checkLoginBtnStatus
{
    if ([self.NewPassword_1.text checkPasswordValid] && [self.NewPassword_2.text checkPasswordValid]&&[self.NewPassword_1.text isEqualToString:self.NewPassword_2.text] ) {
        [self enable:YES button:self.submit_btn];
    }
    else {
        [self enable:NO button:self.submit_btn];
        

    }

    
}

- (void)enable:(BOOL)enable button:(UIButton *)btn
{
    btn.enabled = enable;
}
#pragma mark - action

- (IBAction)submitIsPress:(id)sender {
  
    if (self.resetOperation) {
        return;
    }
    
    __weak RetrivePasswordViewController *vc = self;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    self.resetOperation = [HttpRequest ResetUserPassword:self.UserId password:self.NewPassword_1.text verifyCode:self.VerifyCode completionWithSuccess:^(NSDictionary *dis){
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"RESET_PASSWORD_SUCCESS", nil)];
        vc.resetOperation = nil;
    }failure:^(int errorCode){
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
        vc.resetOperation = nil;
    }];
}

#pragma mark - delegation
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"BackToLogin"]) {
        if (success_flag == 1) {
            return  YES;
        }
    }
    return NO;
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

@end
