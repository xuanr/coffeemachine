//
//  CommentViewController.m
//  coffeeMachine
//
//  Created by Beifei on 6/20/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "CommentViewController.h"
#import "PlaceHolderTextView.h"
#import "CoffeePictureUpdateManager.h"
#import "Util.h"
#import <AddressBookUI/AddressBookUI.h>
#import "AppDelegate.h"
#import "CommentsTableViewController.h"
#import "UIImage+Utilities.h"

@interface CommentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UIImageView *coffeeImg;
@property (weak, nonatomic) IBOutlet UILabel *coffeeName;
@property (weak, nonatomic) IBOutlet UILabel *tim;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet PlaceHolderTextView *commentView;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIView *photoBg;
@property (weak, nonatomic) IBOutlet UIButton *camerBtn;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSOperation *uploadPicOperation;
@property (strong, nonatomic) NSMutableArray *uploadArray;
@property (strong, nonatomic) NSMutableArray *uploadSubviewArray;
@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSOperationQueue *sendQueue;
@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation CommentViewController

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
    self.title = NSLocalizedString(@"Comment", nil);
    
    self.commentView.placeHolder = NSLocalizedString(@"写下你的状态...", nil);
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([CLLocationManager locationServicesEnabled]&& [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
        [self.locationManager startUpdatingLocation];
    }
    else {
        [self switchLocation:NO];
    }
    
    __weak CommentViewController *vc = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        if ([CLLocationManager locationServicesEnabled]&& [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
            [vc.locationManager startUpdatingLocation];
        }
        else {
            [vc switchLocation:NO];
        }
    }];
    
    self.uploadArray = [NSMutableArray array];
    self.uploadSubviewArray = [NSMutableArray array];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"发送", nil) style:UIBarButtonItemStylePlain target:self action:@selector(send)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.sendQueue cancelAllOperations];
    self.sendQueue = nil;
}

- (void)send
{
    if ([self.uploadArray count]==0 && [self.commentView.text isEqualToString:@""]) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"请添加评论", nil)];
        return;
    }
    if (self.sendQueue) {
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    __weak CommentViewController *vc = self;
    NSMutableString *picString = [NSMutableString stringWithString:@""];
    
    if (!self.uploadArray || [self.uploadArray count]==0) {
        
        [HttpRequest commentWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token coffeeId:[self.coffee objectForKey:@"coffeeindent"] comment:self.commentView.text pic:picString longitude:-1 latitude:-1 completionWithSuccess:^{
            vc.sendQueue = nil;
            [SVProgressHUD dismiss];
            
            [vc.navigationController popViewControllerAnimated:NO];
            
            CommentsTableViewController *commentVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"CommentsTableViewController"];
            commentVC.coffee = vc.coffee;
            [vc.navigationController pushViewController:vc animated:YES];
            
        } failure:^(int errorCode) {
            
            NSString *msg = [HttpRequest errorMsg:errorCode];
            [SVProgressHUD showErrorWithStatus:msg];
            
            [vc.sendQueue cancelAllOperations];
            vc.sendQueue = nil;
        }];
        return;
    }
    
    self.sendQueue = [[NSOperationQueue alloc]init];
    for (NSData *data in self.uploadArray) {
        NSOperation *op = [HttpRequest uploadCommentPhotoOPWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token coffeeId:[self.coffee objectForKey:@"coffeeindent"] photo:data completionWithSuccess:^(NSString *pic){
            if (![picString isEqualToString:@""]) {
                [picString appendString:@"_"];
            }
            [picString appendString:pic];
            
            if ([self.sendQueue operationCount]==0) {
                
                
                float longitude = -1;
                float latitude = -1;
                if (self.locationSwitch.on) {
                    longitude = self.currentLocation.coordinate.longitude;
                    latitude = self.currentLocation.coordinate.latitude;
                }
                [HttpRequest commentWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token coffeeId:[self.coffee objectForKey:@"coffeeindent"] comment:self.commentView.text pic:picString longitude:-1 latitude:-1 completionWithSuccess:^{
                    vc.sendQueue = nil;
                    [SVProgressHUD dismiss];
                    
                    [vc.navigationController popViewControllerAnimated:NO];
                    
                    CommentsTableViewController *commentVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"CommentsTableViewController"];
                    commentVC.coffee = vc.coffee;
                    [vc.navigationController pushViewController:vc animated:YES];
                    
                } failure:^(int errorCode) {
                    
                    NSString *msg = [HttpRequest errorMsg:errorCode];
                    [SVProgressHUD showErrorWithStatus:msg];
                    
                    [vc.sendQueue cancelAllOperations];
                    vc.sendQueue = nil;
                }];
            }
        } failure:^(int errorCode) {
            
            NSString *msg = [HttpRequest errorMsg:errorCode];
            [SVProgressHUD showErrorWithStatus:msg];
            
            [vc.sendQueue cancelAllOperations];
            vc.sendQueue = nil;
        }];
        [self.sendQueue addOperation:op];
    }
    
}

#pragma mark - location authorize
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status!=kCLAuthorizationStatusAuthorized) {
        [self switchLocation:NO];
    }
}

#pragma mark - location delegate
- (void)startLocate
{
    if ([CLLocationManager locationServicesEnabled]&& [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
        [self.locationManager startUpdatingLocation];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"友情提醒", nil) message:@"请去设置页面打开定位功能" delegate:self cancelButtonTitle:@"等会再说" otherButtonTitles:@"现在就去", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
    }
    else {
        [self switchLocation:NO];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLGeocoder *geo = [[CLGeocoder alloc]init];
    self.currentLocation = newLocation;
    __weak CommentViewController *vc = self;
    [geo reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count]>0) {
            CLPlacemark *mark = [placemarks objectAtIndex:0];
            if ([mark.ISOcountryCode isEqualToString:@"CN"]) {
                vc.locationLabel.text = [NSString stringWithFormat:@"%@,%@",mark.locality,mark.name];
            }
            else {
                vc.locationLabel.text = [NSString stringWithFormat:@"%@,%@",mark.country,mark.locality];
            }
        }
    }];
    [self.locationManager stopUpdatingLocation];
}

- (void)setCoffee:(NSDictionary *)coffee
{
    _coffee = coffee;
    self.orderNo.text = [coffee objectForKey:@"coffeeindent"];
    self.tim.text = [Util timeString:[[coffee objectForKey:@"paytime"]doubleValue]/1000];
    self.price.text = [NSString stringWithFormat:@"¥ %.2f%@",[[coffee objectForKey:@"price"]doubleValue],NSLocalizedString(@"Yuan", nil)];
    self.coffeeName.text = [coffee objectForKey:@"title"];
    
    UIImage *image = [[CoffeePictureUpdateManager sharedManager]coffeePictureOfId:[coffee objectForKey:@"coffeeid"] atUrl:@""];
    
    if (image) {
        [self.coffeeImg setImage:image];
    }
    else {
        [self.coffeeImg setImage:[UIImage imageNamed:@"icon_small_coffee"]];
        __weak CommentViewController *vc = self;
        [[NSNotificationCenter defaultCenter]addObserverForName:CoffeePictureDownloadFinished object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            NSDictionary *info = [note userInfo];
            UIImage *coffeeImg = [info objectForKey:[coffee objectForKey:@"coffeeid"]];
            if (coffeeImg) {
                [vc.coffeeImg setImage:coffeeImg];
            }
            
        }];
    }
}

#pragma mark - action
- (void)switchLocation:(BOOL)on {
    self.locationSwitch.on = on;
    if (on) {
        self.locationLabel.hidden = NO;
    }
    else {
        self.locationLabel.hidden = YES;
        self.locationLabel.text = @"";
        [self.locationManager stopUpdatingLocation];
    }
}

- (IBAction)switchShowLocation:(id)sender {
    UISwitch *switcher = nil;
    if ([sender isKindOfClass:[UISwitch class]]) {
        switcher = (UISwitch *)sender;
        
        if (switcher.on) {
            [self startLocate];
        }
        
        [self switchLocation:switcher.on];
    }
}

- (IBAction)addPhoto:(id)sender {
    
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Choose Library", nil), NSLocalizedString(@"Take Photo", nil), nil];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        as = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Choose Library", nil), nil];
    }
    
    [as showInView:((AppDelegate *)[UIApplication sharedApplication].delegate).window];
}

- (IBAction)commonComments:(id)sender {
}

- (IBAction)tap:(id)sender {
    [self.commentView resignFirstResponder];
}

- (void)addUploadSubview
{
    for (int i = [self.uploadSubviewArray count]; i < [self.uploadArray count]; i++) {
        UIButton *view = [[UIButton alloc]initWithFrame:CGRectMake(15+i*(50+10), 13, 50, 50)];
        
        NSData *data = [self.uploadArray objectAtIndex:i];
        UIImage *img = [UIImage imageWithData:data];
        img = [img thumbnailOfSize:CGSizeMake(50, 50)];
        [view setBackgroundImage:img forState:UIControlStateNormal];
        view.tag = i;
        [view addTarget:self action:@selector(selectUploadView:) forControlEvents:UIControlEventTouchUpInside];
        [self.photoBg addSubview:view];
        [self.uploadSubviewArray addObject:view];
    }
    
    [self.camerBtn setFrame:CGRectMake(15+[self.uploadArray count]*(50+10), 13, 50, 50)];
    
    if ([self.uploadSubviewArray count]==5) {
        self.camerBtn.hidden = YES;
    }
    else {
        self.camerBtn.hidden = NO;
    }
}

- (void)selectUploadView:(id)sender
{
    CustomPreviewController *vc = [[CustomPreviewController alloc]init];
    vc.dataSource = self;
    vc.delegate = self;
    vc.currentPreviewItemIndex  = ((UIButton *)sender).tag;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteAtIndex:(NSInteger)index
{
    if (index<0 || index>[self.uploadArray count]-1) {
        return;
    }
    [self.uploadArray removeObjectAtIndex:index];
    [self removeUploadViewAtIndex:index];
}

- (void)removeUploadViewAtIndex:(NSInteger)index
{
    UIView *view = [self.uploadSubviewArray objectAtIndex:index];
    [view removeFromSuperview];
    [self.uploadSubviewArray removeObjectAtIndex:index];
    
    for (int i = index; i < [self.uploadSubviewArray count]; i++) {
        UIView *view = [self.uploadSubviewArray objectAtIndex:index];
        [view setFrame:CGRectMake(15+i*(50+10), 13, 50, 50)];
    }
    
    [self.camerBtn setFrame:CGRectMake(15+[self.uploadSubviewArray count]*(50+10), 13, 50, 50)];
    
    if ([self.uploadSubviewArray count]==5) {
        self.camerBtn.hidden = YES;
    }
    else {
        self.camerBtn.hidden = NO;
    }
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}

#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    return [self.uploadArray count];
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    if (idx == -1) {
        return nil;
    }
    NSData *data = [self.uploadArray objectAtIndex:idx];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *appDocumentPath = [[NSString alloc]initWithFormat:@"%@/",[paths objectAtIndex:0]];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.jpg",appDocumentPath,[Util uuid]];
    [data writeToFile:filePath atomically:YES];
    return [NSURL fileURLWithPath:filePath];
}

#pragma mark - QBImageViewController Delegate
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    for (ALAsset *asset in assets) {
        UIImage *img = [UIImage imageWithCGImage:[asset defaultRepresentation].fullResolutionImage];
        NSData *data = UIImageJPEGRepresentation(img, 0.5);
        [self.uploadArray addObject:data];
    }
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    [self addUploadSubview];
}

- (void)QBImagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(img, 0.5);
    [self.uploadArray addObject:data];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self addUploadSubview];
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
    else if (buttonIndex == UIImagePickerControllerSourceTypeCamera) {
        UIImagePickerController *controller = [[UIImagePickerController alloc]init];
        controller.sourceType = buttonIndex;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.maximumNumberOfSelection = 5-[self.uploadArray count];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imagePickerController];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - text view delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=140) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.countDownLabel.text = [NSString stringWithFormat:@"%d",[textView.text length]-140];
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
