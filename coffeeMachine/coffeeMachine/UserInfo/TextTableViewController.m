//
//  TextTableViewController.m
//  coffeeMachine
//
//  Created by Beifei on 5/22/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "TextTableViewController.h"
#import "NSString+Util.h"
#import "SVProgressHUD.h"

@interface TextTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) NSOperation *modifyOperation;

@end

@implementation TextTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    self.title = NSLocalizedString(@"Nickname", nil);
    if (![self.text isEqual:[NSNull null]]) {
        self.textField.text = self.text;
    }
    else {
        self.textField.text = @"";
    }
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.textField becomeFirstResponder];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - action
- (IBAction)save:(id)sender {
    
    NSString *value = [self.textField.text trim];
    NSDictionary *dict = @{@"name":value};
    
    if (self.modifyOperation) {
        return;
    }
    
    __weak TextTableViewController *vc = self;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    self.modifyOperation = [HttpRequest modifyUserInfo:dict user:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token completionWithSuccess:^{
        [[UserInfo sharedInstance]updateUserInfoType:UserInfo_Name value:value];
        
        vc.modifyOperation = nil;
        [SVProgressHUD dismiss];
        
        [vc.navigationController popViewControllerAnimated:YES];
    } failure:^(int errorCode) {
        self.modifyOperation = nil;
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];

    }];
}

#pragma mark - Table view data source
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
