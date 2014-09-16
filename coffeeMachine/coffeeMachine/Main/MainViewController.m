//
//  MainViewController.m
//  coffeeMachine
//
//  Created by Beifei on 5/19/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "MainViewController.h"
#import "CoffeeCell.h"
#import "CommentsTableViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "PayViewController.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionView *bottomCollectionView;

@property (strong, nonatomic) NSArray *coffeeArr;

@property (strong, nonatomic) NSOperation *listOperation;
@property (strong, nonatomic) NSOperation *submitOperation;
@property (strong, nonatomic) NSOperation *cartOperation;
@property (strong, nonatomic) NSOperation *favOperation;

@property (assign, nonatomic) BOOL isCoffeeViewOpen;

@end

@implementation MainViewController

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
    self.title = NSLocalizedString(@"主页", nil);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setMinimumInteritemSpacing:10];
    [layout setItemSize:CGSizeMake(60, 87)];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setSectionInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    
    self.bottomCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 38, 320, 87) collectionViewLayout:layout];
    self.bottomCollectionView.delegate = self;
    self.bottomCollectionView.dataSource = self;
    self.bottomCollectionView.backgroundColor = [UIColor clearColor];
    
    [self.bottomCollectionView registerClass:[NearbyCell class] forCellWithReuseIdentifier:@"nearbyCell"];
    self.isCoffeeViewOpen = NO;
}

- (void)dealloc
{
    [self.listOperation cancel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.listOperation) {
        return;
    }
    
    __weak MainViewController *vc = self;
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading...", nil)];
    self.listOperation = [HttpRequest productListAtPage:1 entrys:100 completionWithSuccess:^(NSArray *arr){
        vc.coffeeArr = arr;
        [vc.collectionView reloadData];
        vc.listOperation = nil;
        [SVProgressHUD dismiss];
    } failure:^(int errorCode) {
        vc.listOperation = nil;
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - uicollectionview delegate
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    if (view == self.collectionView) {
        NSInteger coffeeCount = [self.coffeeArr count];
        
        if (coffeeCount%3==0) {
            return coffeeCount;
        }
        else {
            NSInteger num = coffeeCount/3;
            return num*3+3;
        }
    }
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (cv == self.collectionView) {
        
        if (indexPath.row >= [self.coffeeArr count]) {
            return [cv dequeueReusableCellWithReuseIdentifier:@"laterCoffeeCell" forIndexPath:indexPath];
        }
        CoffeeCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"coffeeCell" forIndexPath:indexPath];
        
        NSDictionary *dict = [self.coffeeArr objectAtIndex:indexPath.row];
        cell.dict = dict;
        
        cell.delegate = self;
        
        return cell;
    }
    else {
        NearbyCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"nearbyCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[NearbyCell alloc]initWithFrame:CGRectMake(0, 0, 60, 87)];
            cell.delegate = self;
        }
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        if (kind == UICollectionElementKindSectionHeader) {
            
            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell" forIndexPath:indexPath];
            
            if (reusableview==nil) {
                reusableview=[[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 320, 149)];
            }
            
            UIImageView *head = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_banner"]];
            [reusableview addSubview:head];
            return reusableview;
        }
//        else if (kind == UICollectionElementKindSectionFooter) {
//            
//            UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footCell" forIndexPath:indexPath];
//            
//            if (reusableview==nil) {
//                reusableview=[[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 320, 125)];
//            }
//            
//            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
//            line.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:216.0/255.0 blue:209.0/255.0 alpha:1.0];
//            
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 300, 12)];
//            label.text = NSLocalizedString(@"NEARBY_COFFEE", nil);
//            label.textColor = [UIColor darkGrayColor];
//            label.backgroundColor = [UIColor clearColor];
//            label.font = [UIFont systemFontOfSize:12.0];
//            
//            [reusableview addSubview:self.bottomCollectionView];
//            [reusableview addSubview:line];
//            [reusableview addSubview:label];
//            return reusableview;
//        }
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row >= [self.coffeeArr count]) {
        return;
    }
    
    if (collectionView == self.collectionView) {
        NSDictionary *data = [self.coffeeArr objectAtIndex:indexPath.row];
        if (data) {
            [self showCoffeeView:data];
        }
        else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Product", nil)];
        }
    }
}

- (void)showCoffeeView:(NSDictionary *)data
{
    self.isCoffeeViewOpen = YES;
    NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"CoffeeMakeView" owner:self options:nil];
    
    CoffeeMakeView *view = [arr objectAtIndex:0];
    if (view!=nil) {
        view.data = data;
        view.delegate = self;
        
        if ([[data objectForKey:@"type"]isEqualToString:@"false"]) {
            CGRect frame = view.frame;
            frame.size.height = 250;
            [view setFrame:frame];
        }
        else {
            if (IPHONE3_5INCH) {
                CGRect frame = view.frame;
                frame.size.height -= 568-480;
                [view setFrame:frame];
            }
        }
        
        [self presentSemiView:view];
    }
}

#pragma mark - nearby delegate
- (void)selectUser
{
    
}

#pragma mark - coffeemake delegate
- (void)close
{
    [self closeCoffeeView];
}

- (void)closeCoffeeView
{
    if (self.isCoffeeViewOpen) {
        self.isCoffeeViewOpen = NO;
        [self dismissSemiModalView];
    }
}

- (void)addToFav:(NSString *)content dosing:(NSString *)dosing completionWithSuccess:(void (^)())completion failure:(void (^)())failure
{
    if (![UserInfo sharedInstance].isLogin) {
        
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.delegate = self;
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else {
        if (self.favOperation) {
            return;
        }
        
        __weak MainViewController *vc = self;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        self.favOperation = [HttpRequest addFavWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token coffee:content dosing:dosing completionWithSuccess:^(NSDictionary *dict){
            vc.favOperation = nil;
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Congraduation, add to favorite successfully!", nil)];
            [[UserInfo sharedInstance]addFav:dict];
            completion();
            
        } failure:^(int errorCode) {
            vc.favOperation = nil;
            NSString *msg = [HttpRequest errorMsg:errorCode];
            [SVProgressHUD showErrorWithStatus:msg];
            failure();
        }];
    }
}

- (void)addToCart:(NSString *)content dosing:(NSString *)dosing num:(NSInteger)num
{
    if (![UserInfo sharedInstance].isLogin) {
        
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.delegate = self;
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else {
        if (self.cartOperation) {
            return;
        }
        
        __weak MainViewController *vc = self;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        self.cartOperation = [HttpRequest addToCartWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token coffee:content dosing:dosing num:num completionWithSuccess:^{
            vc.cartOperation = nil;
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Congraduation, add to cart successfully!", nil)];
            
        } failure:^(int errorCode) {
            vc.cartOperation = nil;
            NSString *msg = [HttpRequest errorMsg:errorCode];
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

- (void)buyContent:(NSString *)content dosing:(NSString *)dosing coffee:(NSDictionary *)coffeeDict
{
    if (![UserInfo sharedInstance].isLogin) {
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.delegate = self;
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else {
        if (self.submitOperation) {
            return;
        }
        
        __weak MainViewController *vc = self;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        self.submitOperation = [HttpRequest submitOrderWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token content:content dosing:dosing source:OrderSource_Other completionWithSuccess:^(NSArray *arr, NSArray *coffeeArray, NSString *orderId){
            vc.submitOperation = nil;
            [SVProgressHUD dismiss];
            
            PayViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"PayViewController"];
            vc.coffeeArr = coffeeArray;
            vc.valueArr = arr;
            vc.indent = orderId;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        } failure:^(int errorCode) {
            vc.submitOperation = nil;
            NSString *msg = [HttpRequest errorMsg:errorCode];
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

#pragma mark - login delegate
- (void)loginSuccess:(id)sender
{
    LoginViewController *vc = (LoginViewController *)sender;
    [vc.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - coffee cell delegate
- (void)comment:(NSDictionary *)dict
{
    CommentsTableViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"CommentsTableViewController"];
    vc.coffee = dict;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */

@end
