//
//  PersonalCityTableViewController.m
//  coffeeMachine
//
//  Created by Beifei on 6/6/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "PersonalCityTableViewController.h"
#import "HttpRequest.h"
#import "UserInfoTableViewController.h"

@interface PersonalCityTableViewController ()

@property (strong, nonatomic) NSArray *cities;

@property (strong, nonatomic) NSOperation *cityOperation;

@end

@implementation PersonalCityTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCities:(NSArray *)cities
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        self.cities = cities;
    }
    return self;
}

- (void)dealloc
{
    [self.cityOperation cancel],self.cityOperation = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = NSLocalizedString(@"District", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    static NSString *CellIdentifier = @"CommonCellID";
    UITableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (commonCell == nil) {
        
        commonCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:CellIdentifier];
        
        commonCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    // 设置cell标题
    id city = [_cities objectAtIndex:row];
    NSString *cityName = nil;
    if ([city isKindOfClass:[NSString class]]) {
        cityName = city;
    }
    else {
        cityName = [city objectForKey:@"state"];
        NSArray *cities = [city objectForKey:@"cities"];
        if ([cities count]>0) {
            commonCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    commonCell.textLabel.text = cityName;
    
    return commonCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    id city = [_cities objectAtIndex:indexPath.row];
    if ([city isKindOfClass:[NSString class]]) {
        NSString *cityName = (NSString *)city;
        
        NSString *cityStr = nil;
        if ([_state isEqualToString:NSLocalizedString(@"中国", nil)]) {
            cityStr = cityName;
        }
        else {
            cityStr = [NSString stringWithFormat:@"%@ %@", _state, cityName];
        }
        
        NSDictionary *dict = @{@"place": cityStr};
        
        if (self.cityOperation) {
            return;
        }
        
        __weak PersonalCityTableViewController *controller = self;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        self.cityOperation = [HttpRequest modifyUserInfo:dict user:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token completionWithSuccess:^{
            
            [[UserInfo sharedInstance]updateUserInfoType:UserInfo_District value:cityStr];
            
            controller.cityOperation = nil;
            [SVProgressHUD dismiss];
            
            NSArray *arr = self.navigationController.viewControllers;
            for (UIViewController *vc in arr) {
                if ([vc isKindOfClass:[UserInfoTableViewController class]] ) {
                    [controller.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
            
        } failure:^(int errorCode) {
            controller.cityOperation = nil;
            NSString *msg = [HttpRequest errorMsg:errorCode];
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }
    else {
        NSString *state = [city objectForKey:@"state"];
        NSArray *cities = [city objectForKey:@"cities"];
        if ([cities count] == 0) {
            
            NSDictionary *dict = @{@"place": state};
            
            if (self.cityOperation) {
                return;
            }
            
            __weak PersonalCityTableViewController *controller = self;
            self.cityOperation = [HttpRequest modifyUserInfo:dict user:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token completionWithSuccess:^{
                
                [[UserInfo sharedInstance]updateUserInfoType:UserInfo_District value:state];
                controller.cityOperation = nil;
                [SVProgressHUD dismiss];
                NSArray *arr = self.navigationController.viewControllers;
                for (UIViewController *vc in arr) {
                    if ([vc isKindOfClass:[UserInfoTableViewController class]] ) {
                        [controller.navigationController popToViewController:vc animated:YES];
                        break;
                    }
                }
                
            } failure:^(int errorCode) {
                controller.cityOperation = nil;
                NSString *msg = [HttpRequest errorMsg:errorCode];
                [SVProgressHUD showErrorWithStatus:msg];
                
            }];
        }
        else
        {
            PersonalCityTableViewController *cityVC = [[PersonalCityTableViewController alloc] initWithCities:cities];
            if ([_state isEqualToString:NSLocalizedString(@"中国", nil)]) {
                cityVC.state = state;
            }
            else
            {
                cityVC.state = _state;
            }
            [self.navigationController pushViewController:cityVC animated:YES];
            return;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
