//
//  PersonalStateViewController.m
//  yixin_iphone
//
//  Created by huangyaowu on 13-4-26.
//  Copyright (c) 2013年 Netease. All rights reserved.
//

#import "PersonalStateViewController.h"
#import "PersonalCityTableViewController.h"

@interface PersonalStateViewController ()

@property (strong, nonatomic) NSArray           *provinces;

@property (strong, nonatomic) NSOperation *stateOperation;

@end

@implementation PersonalStateViewController

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
    [self.stateOperation cancel],self.stateOperation = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTableData];
    [self initUIComponent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化
- (void)initTableData
{
    NSArray *_array = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
    self.provinces = _array;
}

- (void)initUIComponent
{
    self.navigationItem.title = NSLocalizedString(@"District", @"");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_provinces count];
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    static NSString *CellIdentifier = @"CommonCellID";
    UITableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (commonCell == nil) {
        
        commonCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:CellIdentifier];
    }
    
    NSString *state = [[_provinces objectAtIndex:row] objectForKey:@"country"];
    commonCell.textLabel.text = state;
    NSArray *cities = [[_provinces objectAtIndex:row] objectForKey:@"states"];
    if ([cities count]>0) {
        commonCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return commonCell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    NSString *state = [[_provinces objectAtIndex:row] objectForKey:@"country"];
    NSArray *cities = [[_provinces objectAtIndex:row] objectForKey:@"states"];
    
    if ([cities count] == 0) {
        
        NSDictionary *dict = @{@"place": state};
        
        if (self.stateOperation) {
            return;
        }
        
        __weak PersonalStateViewController *controller = self;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        self.stateOperation = [HttpRequest modifyUserInfo:dict user:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token completionWithSuccess:^{
            [[UserInfo sharedInstance]updateUserInfoType:UserInfo_District value:state];
            
            controller.stateOperation = nil;
            [SVProgressHUD dismiss];
            
            [controller.navigationController popViewControllerAnimated:YES];
        } failure:^(int errorCode) {
            controller.stateOperation = nil;
            NSString *msg = [HttpRequest errorMsg:errorCode];
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];

    }
    else {
        PersonalCityTableViewController *cityVC = [[PersonalCityTableViewController alloc] initWithCities:cities];
        cityVC.state = state;
        [self.navigationController pushViewController:cityVC animated:YES];
    }
}

@end
