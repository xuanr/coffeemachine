//
//  PayViewController.m
//  coffeeMachine
//
//  Created by Beifei on 6/25/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "PayViewController.h"
#import "AlixLibService.h"
#import "AlixPayResult.h"
#import "PartnerConfig.h"
#import "DataVerifier.h"
#import "MainViewController.h"
#import "PayResultViewController.h"
#import "XHDrawerController.h"
#import "AppDelegate.h"
#import "AccountViewController.h"

@interface PayCoffeeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coffeeImage;
@property (weak, nonatomic) IBOutlet UILabel *coffeeName;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *dosing;

@property (strong, nonatomic) NSDictionary *coffeeDict;

@end

@implementation PayCoffeeCell

- (void)setCoffeeDict:(NSDictionary *)coffeeDict
{
    _coffeeDict = coffeeDict;
    self.money.text = [NSString stringWithFormat:@"¥%.2f %@",[[self.coffeeDict objectForKey:@"price"]floatValue],NSLocalizedString(@"Yuan", nil)];
    self.coffeeName.text = [self.coffeeDict objectForKey:@"coffeename"];
    self.dosing.text = [self.coffeeDict objectForKey:@"dosing"];
}

@end

@interface PayViewController ()

@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *more;
@property (weak, nonatomic) IBOutlet UIButton *useBalanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet RadioGroup *methodGroup;

@property (weak, nonatomic) IBOutlet UITableView *payCoffeeTableView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *showupBtn;
@property (assign,nonatomic) BOOL showAll;

@property (strong, nonatomic) NSOperation *payOperation;

@end

@implementation PayViewController

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
    
    self.title = NSLocalizedString(@"Pay", nil);
    self.account.text = [UserInfo sharedInstance].mobile;
    
    self.methodGroup.titleArray = [NSArray arrayWithObjects:NSLocalizedString(@"Alipay", nil), NSLocalizedString(@"Wechat", nil), nil];
    self.methodGroup.column = 2;
    self.methodGroup.unselectedBg = [UIImage imageNamed:@"btn_money_cell"];
    self.methodGroup.unselectedTextColor = AccountTextColor;
    self.methodGroup.selectedBg = [UIImage imageNamed:@"btn_money_cell_pressed"];
    self.methodGroup.selectedTextColor = [UIColor whiteColor];
    self.methodGroup.highlightedBg = [UIImage imageNamed:@"btn_money_cell_pressed"];
    self.methodGroup.highlightedTextColor = [UIColor whiteColor];
    self.methodGroup.delegate = self;
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 25, 25)];
    
    if ([[[self navigationController]viewControllers]count]==1) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = item;
    }
    
    self.balance.text = [NSString stringWithFormat:@"¥%.2f %@",[[self.valueArr objectAtIndex:1]floatValue],NSLocalizedString(@"Yuan", nil)];
    
    if ([[self.valueArr objectAtIndex:1]floatValue] == 0) {
        self.useBalanceBtn.enabled = NO;
    }
    else {
        self.useBalanceBtn.enabled = YES;
    }
    
    [self resetLeftLabel];
    
    [self.scrollView setFrame:self.view.bounds];
    if ([self.coffeeArr count]<=2) {
        self.showAll = NO;
        self.payCoffeeTableView.tableFooterView = nil;
    }
    
    [self layout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layout
{
    int height = 0;
    if ([self.coffeeArr count]<=2) {
        height+=[self.coffeeArr count]*70;
    }
    else {
        height+=26;
        if (self.showAll) {
            height+=[self.coffeeArr count]*70;
        }
        else {
            height+=2*70;
        }
    }
    
    int totalHeight=height+10+(self.infoView.frame.size.height+self.payView.frame.size.height);
    [self.scrollView setContentSize:CGSizeMake(320, totalHeight)];
    
    __weak PayViewController *vc = self;
    [UIView animateWithDuration:0.5 animations:^{
        
    } completion:^(BOOL finished) {
        [vc.payCoffeeTableView setFrame:CGRectMake(0, 0, 320, height)];
        
        CGRect frame = vc.infoView.frame;
        frame.origin.y = height+10;
        [vc.infoView setFrame:frame];
        
        CGRect payFrame = vc.payView.frame;
        payFrame.origin.y = frame.origin.y+frame.size.height;
        [vc.payView setFrame:payFrame];
    }];
}

- (IBAction)showup:(id)sender {
    self.showAll = !self.showAll;
    if (self.showAll) {
        [self.showupBtn setTitle:NSLocalizedString(@"Show Part", nil) forState:UIControlStateNormal];
    }
    else {
        [self.showupBtn setTitle:NSLocalizedString(@"Show All", nil) forState:UIControlStateNormal];
    }
    [self layout];
    [self.payCoffeeTableView reloadData];
}

#pragma mark - radio group delegate
- (void)buttonSelected:(RadioGroup *)group
{
    [self checkPayBtn];
}

- (void)checkPayBtn
{
    if (self.methodGroup.selectedIndex>-1||(self.useBalanceBtn.selected && [self.more.text floatValue]==0)) {
        [self enablePayBtn:YES];
    }
    else {
        [self enablePayBtn:NO];
    }
}

- (void)enablePayBtn:(BOOL)enable
{
    self.payBtn.enabled = enable;
    
    if (enable) {
        [self.payBtn setBackgroundColor:OrangeColor];
    }
    else {
        [self.payBtn setBackgroundColor:[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0]];
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

#pragma mark - action
- (void)back:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 ) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?l=en&mt=8"]];
    }
}


- (IBAction)pay:(id)sender {
    if (self.payOperation) {
        return;
    }
    
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];

    __weak PayViewController *vc = self;
    self.payOperation = [HttpRequest payOrderWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token indent:self.indent method:(self.methodGroup.selectedIndex>-1)?PayType_Alipay:PayType_Balance useBalance:self.useBalanceBtn.selected completionWithSuccess:^(NSString *result){
        vc.payOperation = nil;
        [SVProgressHUD dismiss];
        if (result) {
            if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
                [SVProgressHUD dismiss];
                UIAlertView *view = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"友情提醒", nil) message:NSLocalizedString(@"您还没安装支付宝的客户端,请先安装",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL",nil) otherButtonTitles:NSLocalizedString(@"安装", nil), nil];
                [view show];
                return;
            }
            [AlixLibService payOrder:result AndScheme:@"coffeeMachinePay" seletor:@selector(paymentResult:) target:self];
        }
        else {
            PayResultViewController *pay = [[PayResultViewController alloc]initWithType:ResultType_Pay status:YES];
            NSArray *arr = vc.navigationController.viewControllers;
            UIViewController *root = [arr objectAtIndex:0];
            
            UIViewController *rootVC = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
            if ([root isKindOfClass:[PayViewController class]]) {
                [vc.navigationController dismissViewControllerAnimated:YES completion:nil];
                
                if ([rootVC isKindOfClass:[XHDrawerController class]]) {
                    XHDrawerController *drawerController = (XHDrawerController *)rootVC;
                    UIViewController *nav = drawerController.centerViewController;
                    if ([nav isKindOfClass:[UINavigationController class]]) {
                        
                        NSArray *navArr = ((UINavigationController *)nav).viewControllers;
                        UIViewController *main = [navArr objectAtIndex:0];
                        
                        if ([main isKindOfClass:[MainViewController class]]) {
                            MainViewController *rootMain = (MainViewController *)main;
                            
                            [rootMain closeCoffeeView];
                            [((UINavigationController *)nav) pushViewController:pay animated:YES];
                        }
                    }
                }
            }
            else {
                if ([rootVC isKindOfClass:[XHDrawerController class]]) {
                    
                    XHDrawerController *drawerController = (XHDrawerController *)rootVC;
                    MainViewController *center = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"MainViewController"];
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:center];
                    
                    [nav pushViewController:pay animated:NO];
                    drawerController.centerViewController = nav;
                }
            }
            
        }
    } failure:^(int errorCode) {
        vc.payOperation = nil;
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (IBAction)useBalance:(id)sender {
    self.useBalanceBtn.selected = !self.useBalanceBtn.selected;
    [self resetLeftLabel];
    [self checkPayBtn];
}

- (IBAction)recharge:(id)sender {
    AccountViewController *vc = [[UIStoryboard storyboardWithName:@"UserStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"AccountViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)resetLeftLabel
{
    if (self.useBalanceBtn.selected) {
        NSNumber *left = [self.valueArr objectAtIndex:2];
        if ([left floatValue]<0) {
            self.more.text = [NSString stringWithFormat:@"¥0.00 %@",NSLocalizedString(@"Yuan", nil)];
        }
        else {
            self.more.text = [NSString stringWithFormat:@"¥%.2f %@",[left floatValue],NSLocalizedString(@"Yuan", nil)];
        }
    }
    else {
        self.more.text = [NSString stringWithFormat:@"¥%.2f %@",[[self.valueArr objectAtIndex:0] floatValue],NSLocalizedString(@"Yuan", nil)];
    }
}

#pragma mark - table delegate and datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.coffeeArr count]<2) {
        return [self.coffeeArr count];
    }
    else {
        if (self.showAll) {
            return [self.coffeeArr count];
        }
        else {
            return 2;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayCoffeeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayCoffeeCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[PayCoffeeCell alloc]init];
    }
    cell.coffeeDict = [self.coffeeArr objectAtIndex:indexPath.row];
    return cell;
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

@end
