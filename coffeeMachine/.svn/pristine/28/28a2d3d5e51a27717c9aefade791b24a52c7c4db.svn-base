//
//  UserInfoTableViewController.m
//  coffeeMachine
//
//  Created by Beifei on 5/20/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "UserInfoTableViewController.h"
#import "TextTableViewController.h"
#import "MailBindViewController.h"
#import "UserTextTableViewCell.h"
#import "SexSelectTableViewController.h"
#import "UIImage+Utilities.h"
#import "AppDelegate.h"
#import "PictureDownloadManager.h"

@interface UserInfoTableViewController ()

@property (nonatomic, strong) NSArray *userArray;
@property (nonatomic, strong) UIImage *userAvatar;

@property (nonatomic, strong) NSOperation *avtarOperation;
@property (nonatomic, strong) NSOperation *modifyAvatarOperation;
@property (nonatomic, strong) NSOperation *infoOperation;

@end

@implementation UserInfoTableViewController

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
    [self.avtarOperation cancel],self.avtarOperation = nil;
    [self.modifyAvatarOperation cancel],self.modifyAvatarOperation = nil;
    [self.infoOperation cancel],self.infoOperation = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"User", nil);
    
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.userArray = [[UserInfo sharedInstance]userInfo];
    [self fetchUserInfo];
    [self fetchAvatar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.userArray = [[UserInfo sharedInstance]userInfo];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    NSData *data = UIImageJPEGRepresentation(editedImage, 1.0);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __weak UserInfoTableViewController *vc = self;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    self.modifyAvatarOperation = [HttpRequest modifyAvatarWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token avatar:data completionWithSuccess:^(NSString *response) {
        [UserInfo sharedInstance].userAvatar = [editedImage makeImageRounded];
        [vc.tableView reloadData];
        vc.modifyAvatarOperation = nil;
        [SVProgressHUD dismiss];
    } failure:^(int errorCode) {
        vc.modifyAvatarOperation = nil;
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.sourceType = buttonIndex;
    controller.delegate = self;
    controller.allowsEditing = YES;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 80;
    }
    else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Choose Library", nil), NSLocalizedString(@"Take Photo", nil), nil];
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            as = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Choose Library", nil), nil];
        }
        
        [as showInView:((AppDelegate *)[UIApplication sharedApplication].delegate).window];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [NSArray arrayWithObjects:@"userInfoIconCell", @"userInfoNickCell", @"userInfoSexCell", @"userInfoDistrictCell", @"userInfoEmailCell",nil];
    
    NSArray *leftTextArr = [NSArray arrayWithObjects:NSLocalizedString(@"Nick", nil),NSLocalizedString(@"Gender", nil),NSLocalizedString(@"District", nil),NSLocalizedString(@"Email", nil), nil];
    
    UserTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:arr[indexPath.row]];
    if (cell == nil) {
        cell = [[UserTextTableViewCell alloc]init];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if (indexPath.row == 0) {
        if ([UserInfo sharedInstance].smallAvatar == nil) {
            [cell.imageView setImage:[UIImage imageNamed:@"img_avatar"]];
        }
        else {
            [cell.imageView setImage:[[UserInfo sharedInstance].smallAvatar makeImageRounded]];
        }
        cell.detailTextLabel.text = NSLocalizedString(@"Change Avatar", nil);
        return cell;
    }
    
    cell.textLabel.text = leftTextArr[indexPath.row-1];
    if (self.userArray != nil) {
        id text = self.userArray[indexPath.row-1];
        if (text != [NSNull null]) {
            if (indexPath.row == 2) {
                NSInteger gender = [text integerValue];
                if (gender == 1) {
                    cell.detailTextLabel.text = NSLocalizedString(@"Male", nil);
                }
                else {
                    cell.detailTextLabel.text = NSLocalizedString(@"Female", nil);
                }
            }
            else {
                cell.detailTextLabel.text = (NSString *)text;
            }
        }
        else {
            cell.detailTextLabel.text = NSLocalizedString(@"N/A", nil);
        }
    }
    
    return cell;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:@"nickPushViewController"]) {
        TextTableViewController *vc = (TextTableViewController *)segue.destinationViewController;
        vc.text = self.userArray[UserInfo_Name];
    }
    else if ([identifier isEqualToString:@"mailPushViewController"]) {
        MailBindViewController *vc = (MailBindViewController *)segue.destinationViewController;
        vc.text = self.userArray[UserInfo_Mail];
    }
    else if ([identifier isEqualToString:@"genderPushViewController"]) {
        SexSelectTableViewController *vc = (SexSelectTableViewController *)segue.destinationViewController;
        vc.gender = self.userArray[UserInfo_Gender];
    }
}

#pragma mark - http request
- (void)fetchUserInfo
{
    if (self.infoOperation) {
        return;
    }
    __weak UserInfoTableViewController *vc = self;
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    self.infoOperation =  [HttpRequest userInfo:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token completionWithSuccess:^(NSArray *userArray){
        [UserInfo sharedInstance].userInfo = [NSMutableArray arrayWithArray:userArray];
        vc.userArray = userArray;
        [vc.tableView reloadData];
        
        vc.infoOperation = nil;
        [SVProgressHUD dismiss];
        
    } failure:^(int errorCode) {
        vc.infoOperation = nil;
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)fetchAvatar
{
    if (self.avtarOperation) {
        return;
    }
    
    if ([UserInfo sharedInstance].middleAvatar==nil) {
        __weak UserInfoTableViewController *vc = self;
        self.avtarOperation = [HttpRequest avatarWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token offset:0 size:AvatarSize_Small completionWithSuccess:^(NSString *url){
            UIImage *img = [[PictureDownloadManager sharedManager]pictureOfUrl:url];
            if (img) {
                [[UserInfo sharedInstance]setSmallAvatar:img];
                [vc.tableView reloadData];
            }
            else {
                [[NSNotificationCenter defaultCenter]addObserverForName:PictureDownloadFinishedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                    NSDictionary *info = [note userInfo];
                    UIImage *img = [info objectForKey:url];
                    [[UserInfo sharedInstance]setSmallAvatar:img];
                    [vc.tableView reloadData];
                }];
            }
            vc.avtarOperation = nil;
        } failure:^(int errorCode) {
            vc.avtarOperation = nil;
        }];
    }
}

@end
