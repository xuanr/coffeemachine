//
//  AccountViewController.m
//  coffeeMachine
//
//  Created by Beifei on 5/19/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "AccountViewController.h"
#import "NSString+Util.h"
#import "AlixLibService.h"
#import "AlixPayResult.h"
#import "PartnerConfig.h"
#import "DataVerifier.h"
#import "SVProgressHUD.h"

typedef enum
{
    ChargeType_Alipay,
    ChargeType_Weixin
} ChargeType;

@interface AccountViewController ()

@property (weak, nonatomic) IBOutlet RadioGroup *amountGroup;
@property (weak, nonatomic) IBOutlet RadioGroup *methodGroup;

@property (weak, nonatomic) IBOutlet UITextField *otherMoneyTextField;
@property (weak, nonatomic) IBOutlet UIImageView *otherMoneyView;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *remainLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (nonatomic, strong) NSArray *amountArray;

@property (nonatomic, strong) NSString *amount;

@property (nonatomic, strong) NSOperation *rechargeOperation;
@property (nonatomic, strong) NSOperation *remainOperation;

@end

@implementation AccountViewController

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
    self.title = NSLocalizedString(@"Account", nil);
    
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)dealloc
{
    [self.rechargeOperation cancel],self.rechargeOperation = nil;
    [self.remainOperation cancel],self.remainOperation = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.scrollView setFrame:self.view.bounds];
    [self.scrollView setContentSize:CGSizeMake(320, 504)];
}

- (void)initUI
{
    self.accountLabel.text = [UserInfo sharedInstance].mobile;
    
    self.amountArray = [NSArray arrayWithObjects:@"15", @"20", @"30", @"50", @"100", @"200",nil];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[self.amountArray count]];
    for (NSString *title in self.amountArray) {
        NSString *string = [NSString stringWithFormat:@"%@%@ ",title,NSLocalizedString(@"Yuan", nil)];
        [arr addObject:string];
    }
    self.amountGroup.titleArray = (NSArray *)arr;
    self.amountGroup.column = 2;
    self.amountGroup.unselectedBg = [UIImage imageNamed:@"btn_money_cell"];
    self.amountGroup.unselectedTextColor = AccountTextColor;
    self.amountGroup.selectedBg = [UIImage imageNamed:@"btn_money_cell_pressed"];
    self.amountGroup.selectedTextColor = [UIColor whiteColor];
    self.amountGroup.highlightedBg = [UIImage imageNamed:@"btn_money_cell_pressed"];
    self.amountGroup.highlightedTextColor = [UIColor whiteColor];
    self.amountGroup.delegate = self;
    
    self.methodGroup.titleArray = [NSArray arrayWithObjects:NSLocalizedString(@"Alipay", nil), NSLocalizedString(@"Wechat", nil), nil];
    self.methodGroup.column = 2;
    self.methodGroup.unselectedBg = [UIImage imageNamed:@"btn_money_cell"];
    self.methodGroup.unselectedTextColor = AccountTextColor;
    self.methodGroup.selectedBg = [UIImage imageNamed:@"btn_money_cell_pressed"];
    self.methodGroup.selectedTextColor = [UIColor whiteColor];
    self.methodGroup.highlightedBg = [UIImage imageNamed:@"btn_money_cell_pressed"];
    self.methodGroup.highlightedTextColor = [UIColor whiteColor];
    self.methodGroup.delegate = self;
    
    //self.accountLabel.text = [NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfo[UserInfo_Name]];
    [self enableRechargeBtn:NO];
    [self checkBalance];
}

- (void)checkBalance
{
    if (self.remainOperation!=nil) {
        return;
    }
    __weak AccountViewController *vc = self;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    self.remainOperation = [HttpRequest remainWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token completionWithSuccess:^(NSNumber * remain) {
        vc.remainLabel.text = [NSString stringWithFormat:@"%.2f %@",[remain doubleValue],NSLocalizedString(@"Yuan", nil)];
        vc.remainOperation = nil;
        [SVProgressHUD dismiss];
    } failure:^(int errorCode) {
        vc.remainOperation = nil;
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
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

#pragma mark - notification

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    [self checkBalance];
}

- (void)checkRechargeBtn
{
    if (self.methodGroup.selectedIndex>-1&&(self.amountGroup.selectedIndex>-1||![self.otherMoneyTextField.text isEmpty]))
    {
        [self enableRechargeBtn:YES];
    }
    else {
        [self enableRechargeBtn:NO];
    }
}

- (void)enableRechargeBtn:(BOOL)enable
{
    self.rechargeBtn.enabled = enable;
    
    if (enable) {
        [self.rechargeBtn setBackgroundColor:OrangeColor];
    }
    else {
        [self.rechargeBtn setBackgroundColor:[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0]];
    }
}

- (void)resetOtherMoney
{
    double value = [self.otherMoneyTextField.text doubleValue];
    
    if (value == 0) {
        self.otherMoneyTextField.text = @"";
    }
    
    if (![self.otherMoneyTextField.text isEmpty]) {
        self.amount = [NSString stringWithFormat:@"%.2f",value];
        [self.otherMoneyTextField setText:[NSString stringWithFormat:@"%@%@ ",self.amount,NSLocalizedString(@"Yuan", nil)]];
    }
}

#pragma mark - alipay result
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                NSLog(@"success");
                //验证签名成功，交易结果无篡改
			}
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
    
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?l=en&mt=8"]];
    }
}

#pragma mark - action
- (IBAction)recharge:(id)sender {
    
    if (self.rechargeOperation!=nil) {
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
        [SVProgressHUD dismiss];
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"友情提醒", nil) message:NSLocalizedString(@"您还没安装支付宝的客户端,请先安装",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL",nil) otherButtonTitles:NSLocalizedString(@"安装", nil), nil];
        [view show];
        return;
    }
    
    NSString *money = self.amount;
    if (self.amountGroup.selectedIndex>-1) {
        money = [self.amountArray objectAtIndex:self.amountGroup.selectedIndex];
    }
    
    __weak AccountViewController *vc = self;
    self.rechargeOperation = [HttpRequest rechargeWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token money:money completionWithSuccess:^(NSString *response){
        NSLog(@"pay string:%@",response);
        vc.rechargeOperation = nil;
        [AlixLibService payOrder:response AndScheme:@"coffeeMachineRecharge" seletor:@selector(paymentResult:) target:self];
        [SVProgressHUD dismiss];
    } failure:^(int errorCode) {
        vc.rechargeOperation = nil;
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - radio group delegate
- (void)buttonSelected:(RadioGroup *)group
{
    if (group == self.amountGroup) {
        [self.otherMoneyTextField setText:@""];
        self.amount = @"";
        [self.otherMoneyView setImage:[UIImage imageNamed:@"btn_other_money_cell"]];
        [self.otherMoneyTextField setTextColor:AccountTextColor];
        [self.otherMoneyTextField resignFirstResponder];
    }
    [self checkRechargeBtn];
}

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resetOtherMoney];
    [textField resignFirstResponder];
    [self checkRechargeBtn];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.otherMoneyTextField.text = self.amount;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEmpty]) {
        [self.otherMoneyView setImage:nil];
        self.otherMoneyTextField.textColor = [UIColor whiteColor];
        [self.amountGroup unselectAll];
    }
    else {
        [self.otherMoneyView setImage:[UIImage imageNamed:@"btn_other_money_cell"]];
        [self.otherMoneyTextField setTextColor:AccountTextColor];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    double num = [text doubleValue];
    
    if (num>200) {
        return NO;
    }
    return YES;
}

#pragma mark - gesture
- (IBAction)tap:(id)sender {
    [self resetOtherMoney];
    [self.otherMoneyTextField resignFirstResponder];
    [self checkRechargeBtn];
}

@end
