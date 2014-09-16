//
//  AboutViewController.m
//  coffeeMachine
//
//  Created by xuanr on 14-7-30.
//  Copyright (c) 2014年 iChuansuo. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (nonatomic, strong) NSOperation *checkOperation;
@property (nonatomic, strong) NSOperation *setlabelOption;
@property (nonatomic, strong) NSString *downloadUrl;
@end

@implementation AboutViewController

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
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.scrollEnabled = NO;
//    self.view.backgroundColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
    [self setlabel];
    self.title = NSLocalizedString(@"关于", nil); 
}
-(void)setlabel
{
    __weak AboutViewController *obj = self;
    self.setlabelOption = [HttpRequest versionCompletionWithSuccess:^(NSString *version, NSString *updateUrl) {
        
        NSDictionary *dict = [[NSBundle mainBundle]infoDictionary];
        NSString *ver = [dict objectForKey:(NSString*)kCFBundleVersionKey];
        self.downloadUrl = updateUrl;
        NSString *label_string = [[NSString stringWithFormat:@"i cafe "]stringByAppendingString:ver];
        [self.label setText:label_string];
        
    } failure:^(int errorCode) {
        obj.setlabelOption = nil;
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)versionCheck
{
    if (self.checkOperation) {
        return;
    }
    __weak AboutViewController *obj = self;
    self.checkOperation = [HttpRequest versionCompletionWithSuccess:^(NSString *version, NSString *updateUrl) {
        
        NSDictionary *dict = [[NSBundle mainBundle]infoDictionary];
        NSString *ver = [dict objectForKey:(NSString*)kCFBundleVersionKey];
        self.downloadUrl = updateUrl;
        
        if (![ver isEqualToString:version]) {
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"友情提醒", nil) message:NSLocalizedString(@"有更新版本哦～",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"晚点再说", nil) otherButtonTitles:NSLocalizedString(@"现在就去",nil), nil];
            [view show];
        }else
        {
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"友情提醒", nil) message:NSLocalizedString(@"已经是最新版哦～",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [view show];
        }
        
    } failure:^(int errorCode) {
        obj.checkOperation = nil;
    }];
}

#pragma mark - tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  2;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0:
            cell = [self.tableview dequeueReusableCellWithIdentifier:@"aboutCell_1"];
            break;
        case 1:
            cell = [self.tableview dequeueReusableCellWithIdentifier:@"aboutCell_2"];
            break;
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did selectRow is called");
    if (indexPath.row == 0) {
        [self versionCheck];
    }
}



#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.checkOperation = nil;
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.downloadUrl]];
    }
}
//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
