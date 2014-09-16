//
//  SexSelectTableViewController.m
//  coffeeMachine
//
//  Created by Beifei on 5/22/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "SexSelectTableViewController.h"
#import "HttpRequest.h"

@interface SexSelectTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *maleImage;
@property (weak, nonatomic) IBOutlet UIImageView *femaleImage;

@property (nonatomic, strong) NSOperation *modifyOperation;

@end

@implementation SexSelectTableViewController

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
    [self.modifyOperation cancel],self.modifyOperation = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Sex", nil);
    
    if (![self.gender isEqual:[NSNull null]]) {
        NSInteger g = [self.gender integerValue];
        if (g==1) {
            self.maleImage.hidden = NO;
            self.femaleImage.hidden = YES;
        }
        else {
            self.maleImage.hidden = YES;
            self.femaleImage.hidden = NO;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = @{@"gender": [NSNumber numberWithInt:indexPath.row+1]};
    
    if (self.modifyOperation) {
        return;
    }
    
    __weak SexSelectTableViewController *vc = self;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    self.modifyOperation = [HttpRequest modifyUserInfo:dict user:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token completionWithSuccess:^{
        [[UserInfo sharedInstance]updateUserInfoType:UserInfo_Gender value:[NSString stringWithFormat:@"%d",indexPath.row+1]];
        
        vc.modifyOperation = nil;
        [SVProgressHUD dismiss];
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(int errorCode) {
        vc.modifyOperation = nil;
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
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
