//
//  SettingViewController.m
//  coffeeMachine
//
//  Created by Beifei on 5/20/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "SettingViewController.h"
#import "RetrivePasswordViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SettingViewController

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
    self.title = NSLocalizedString(@"Setting", nil);
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 25, 25)];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

- (IBAction)back:(id)sender
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([UserInfo sharedInstance].isLogin) {
        return 3;
    }
    else {
        return 2;
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            if ([UserInfo sharedInstance].isLogin ) {
                cell = [self.tableview dequeueReusableCellWithIdentifier:@"setCell_1"];
            }
            else {
                cell = [self.tableview dequeueReusableCellWithIdentifier:@"setCell_2"];
            }
           
        }
            break;
        case 1:
        {
            if ([UserInfo sharedInstance].isLogin ) {
                cell = [self.tableview dequeueReusableCellWithIdentifier:@"setCell_2"];
            }
            else {
                cell = [self.tableview dequeueReusableCellWithIdentifier:@"setCell_3"];
            }
            
        }break;
        case 2:
        {
            cell = [self.tableview dequeueReusableCellWithIdentifier:@"setCell_3"];

          
        }break;
            
        default:
        {
            NSLog(@"Wrong row!!!!");
        }
            break;
    }
  
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
