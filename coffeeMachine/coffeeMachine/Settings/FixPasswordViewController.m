//
//  FixPasswordViewController.m
//  coffeeMachine
//
//  Created by xuanr on 14-7-28.
//  Copyright (c) 2014年 iChuansuo. All rights reserved.
//

#import "FixPasswordViewController.h"
#import "NSString+Util.h"
#import "SVProgressHUD.h"
#import "HttpRequest.h"

@interface FixPasswordViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *Password_old;
@property (strong, nonatomic) IBOutlet UITextField *Password_new;
@property (strong, nonatomic) IBOutlet UIButton *Submit;
@property (strong, nonatomic) UITextField *currentTextField;
@property (nonatomic, strong) NSOperation *resetOperation;


@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapgreture;
@end

@implementation FixPasswordViewController

- (IBAction)SubmitIsPress:(id)sender {
    if (![UserInfo sharedInstance].isLogin) {
         [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"INVALID_User", nil)];
    }else{
        NSLog(@"%@",[UserInfo sharedInstance].userId);
        if (self.resetOperation) {
            return;
        }
        
        __weak FixPasswordViewController *vc = self;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        self.resetOperation = [HttpRequest UpdateUserPassword:[UserInfo sharedInstance].userId OldPassword:[[self.Password_old.text trim]md5]  NewPassword:[[self.Password_new.text trim]md5] Token:[UserInfo sharedInstance].token completionWithSuccess:^(NSDictionary *dis){
            vc.resetOperation = nil;
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"RESET_PASSWORD_SUCCESS", nil)];
            [vc.navigationController popViewControllerAnimated:YES];
        } failure:^(int errorCode){
            vc.resetOperation = nil;
            NSString *msg = [HttpRequest errorMsg:errorCode];
            [SVProgressHUD showErrorWithStatus:msg];
        }];

    }

    
}

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
    self.title = NSLocalizedString(@"修改密码", nil);
    // Do any additional setup after loading the view.
    [self initUI];
    self.title = NSLocalizedString(@"修改密码", nil);
//    [self initUI];
}
-(IBAction)tap:(id)sender
{
    NSLog(@"tap is called");
    [self.currentTextField resignFirstResponder];
    self.currentTextField = nil;
    [self CheckSubmit];
   
}
-(void)CheckSubmit
{
    if ([self.Password_old.text checkPasswordValid] && [self.Password_new.text checkPasswordValid] ) {
        self.Submit.enabled = YES;
        
    }
    else {
        self.Submit.enabled = NO;
        
        
    }

}
-(void)initUI
{

//    self.tapgreture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    self.tapgreture.numberOfTouchesRequired = 1;
    self.tapgreture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.tapgreture];
    self.Submit.enabled = NO;
    
    self.Password_old.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.Password_old.placeholder = NSLocalizedString(@"请输入原密码", nil);
    self.Password_old.secureTextEntry = YES;
    self.Password_old.delegate = self;
    
    self.Password_new.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.Password_new.placeholder = NSLocalizedString(@"请输入新密码", nil);
    self.Password_new.secureTextEntry = YES;
    self.Password_new.delegate = self;
    
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.Password_old.frame.size.height-0.5, 320, 0.5)];
//    line.backgroundColor = SeperatorColor;
//    [self.view addSubview:line];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self CheckSubmit];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.Password_old) {
        if (![self.Password_old.text checkPasswordValid]&&[self.Password_old.text length]) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"INVALID_PASSWORD", nil)];
        }
    }else
    {
        if (![self.Password_new.text checkPasswordValid]&&[self.Password_new.text length]) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"INVALID_PASSWORD", nil)];
        }
    }
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
