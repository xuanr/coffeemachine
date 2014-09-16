//
//  FavoriteTableViewController.m
//  coffeeMachine
//
//  Created by Beifei on 6/12/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "FavoriteTableViewController.h"
#import "CartTableViewController.h"

@interface FavoriteTableViewController ()

@property (nonatomic, strong) NSMutableArray *favArray;

@end

@implementation FavoriteTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = NSLocalizedString(@"Favorite", nil);
    self.favArray = [UserInfo sharedInstance].favArr;
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"btn_big_cart"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cart:) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 25, 25)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cart:(id)sender
{
    CartTableViewController *vc = [[UIStoryboard storyboardWithName:@"UserStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"CartTableViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.favArray count]==0) {
        return 1;
    }
    return [self.favArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.favArray count]==0) {
        return [tableView dequeueReusableCellWithIdentifier:@"blankFavCell" forIndexPath:indexPath];
    }
    
    FavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[FavoriteTableViewCell alloc]init];
    }
    cell.favDict = [self.favArray objectAtIndex:indexPath.row];
    cell.delgate = self;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if ([self.favArray count]) {
        return NO;
    }
    return YES;
}
 
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self deleteFav:[self.favArray objectAtIndex:indexPath.row]];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)deleteFav:(NSDictionary *)dict
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [HttpRequest removeFavWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token coffee:[dict objectForKey:@"coffeeid"] dosing:[dict objectForKey:@"dosing"] completionWithSuccess:^{
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Congraduation, delete favorite successfully!", nil)];
        
        NSInteger index = [self.favArray indexOfObject:dict];
        [[UserInfo sharedInstance] removeFav:dict];
        if ([self.favArray count]>0) {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            [self.tableView reloadData];
        }
    } failure:^(int errorCode) {
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - fav delegate 
- (void)addToCart:(NSDictionary *)dict
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [HttpRequest addToCartWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token coffee:[dict objectForKey:@"coffeeid"] dosing:[dict objectForKey:@"dosing"] num:1 completionWithSuccess:^{
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Congraduation, add to cart successfully!", nil)];
    } failure:^(int errorCode) {
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
