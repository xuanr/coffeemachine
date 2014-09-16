//
//  OrderTableViewController.m
//  coffeeMachine
//
//  Created by Beifei on 5/19/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "OrderTableViewController.h"
#import "OrderTableViewCell.h"
#import "CommentViewController.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

typedef enum
{
    FilterCellType_All,
    FilterCellType_Taken,
    FilterCellType_Untaken,
    
    FilterCellType_Num
}FilterCellType;

@interface FilterCell:UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *mark;
@property (nonatomic, strong) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *seperator;

@property (nonatomic, assign) BOOL isSelected;

@end

@implementation FilterCell

- (id)init
{
    NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"filterTableViewCell" owner:nil options:nil];
    if ([arr count]>0) {
        self = [arr objectAtIndex:0];
    }
    else {
        self = [super init];
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected
{
    if (isSelected) {
        self.mark.hidden = NO;
        self.label.textColor = [UIColor whiteColor];
    }
    else {
        self.mark.hidden = YES;
        self.label.textColor = [UIColor blackColor];
    }
}

- (void)addSeperatorLine:(BOOL)add
{
    if (add) {
        self.seperator.hidden = NO;
    }
    else {
        self.seperator.hidden = YES;
    }
}

@end

@interface OrderTableViewController ()

@property (nonatomic, strong) UIView *mapBg;
@property (nonatomic, strong) MKMapView *map;

@property (nonatomic, assign) BOOL isContinued;
@property (nonatomic, strong) NSMutableArray *orderArray;
@property (nonatomic, strong) NSOperation *fetchOperation;
@property (nonatomic, strong) NSOperation *takeOperation;
@property (nonatomic, strong) NSOperation *cancelOperation;

@property (nonatomic, strong) UITableView *filterTableView;
@property (nonatomic, strong) UIView *filterView;

@property (nonatomic, assign) FilterCellType selectedType;

@end

@implementation OrderTableViewController

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
    self.title = NSLocalizedString(@"Order", nil);
    self.orderArray = [NSMutableArray array];
    [self fetchOrders];
    self.isContinued = YES;
    
    self.selectedType = FilterCellType_All;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.filterView removeFromSuperview];
}

#pragma mark - fetch orders
- (void)fetchOrders
{
    __weak OrderTableViewController *vc = self;
    NSInteger page = [self.orderArray count]/PAGE_ENTRYS+1;
    
    if (self.fetchOperation) {
        return;
    }
    
    self.fetchOperation = [HttpRequest orderListWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token page:page type:[self orderType] completionWithSuccess:^(NSArray *array) {
        [vc.orderArray addObjectsFromArray:array];
        [vc.tableView reloadData];
        [vc setupActivityIndicatorView:NO];
        vc.fetchOperation = nil;
    } failure:^(int errorCode) {
        [vc setupActivityIndicatorView:NO];
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
        vc.fetchOperation = nil;
    }];
}

- (OrderType)orderType
{
    switch (self.selectedType) {
        case FilterCellType_Taken:
            return OrderType_Taken;
        case FilterCellType_Untaken:
            return OrderType_Untaken;
        default:
            return OrderType_All;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint contentOffsetPoint = self.tableView.contentOffset;
    CGSize contentSize = self.tableView.contentSize;
    CGRect frame = self.tableView.frame;
    
    if (contentOffsetPoint.y + frame.size.height - contentSize.height >= 0)
    {
        if ([self isContinueLoad])
        {
            UIActivityIndicatorView *ac = (UIActivityIndicatorView*)[self.tableView.tableFooterView
                                                                     viewWithTag:kActivityIndicatorViewTag];
            if (ac == nil)
            {
                [self setupActivityIndicatorView:YES];
                
                [self performSelector:@selector(fetchOrders) withObject:nil afterDelay:0.1f];
            }
        }
    }
}

- (void)setupActivityIndicatorView:(BOOL)isShow
{
    if (isShow)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        UIActivityIndicatorView *ac = [[UIActivityIndicatorView alloc]
                                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        ac.center = headerView.center;
        ac.hidden = YES;
        ac.tag = kActivityIndicatorViewTag;
        [headerView addSubview:ac];
        self.tableView.tableFooterView = headerView;
        
        [ac startAnimating];
    }
    else
    {
        UIActivityIndicatorView *ac = (UIActivityIndicatorView*)[self.tableView.tableHeaderView
                                                                 viewWithTag:kActivityIndicatorViewTag];
        ac.hidden = YES;
        [ac stopAnimating];
        [ac removeFromSuperview];
        
        self.tableView.tableFooterView = nil;
    }
}


// 判断是否有需要继续读取的数据
- (BOOL)isContinueLoad
{
    if (self.isContinued) {
        if ([self.orderArray count]%PAGE_ENTRYS==0) {
            return YES;
        }
        else{
            self.isContinued = NO;
        }
    }
    return self.isContinued;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.filterTableView) {
        return 30;
    }
    NSArray *arr = [self.orderArray objectAtIndex:indexPath.row];
    return [OrderTableViewCell height:[arr count]-1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.filterTableView) {
        return 3;
    }
    else {
        return [self.orderArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.filterTableView) {
        FilterCell *cell = [[FilterCell alloc]init];
        
        if (indexPath.row == self.selectedType) {
            cell.isSelected = YES;
        }
        else {
            cell.isSelected = NO;
        }
        
        if (indexPath.row == FilterCellType_Num) {
            [cell addSeperatorLine:NO];
        }
        else {
            [cell addSeperatorLine:YES];
        }
        
        switch (indexPath.row) {
            case FilterCellType_All:
            {
                cell.label.text = NSLocalizedString(@"全部订单", nil);
                break;
            }
            case FilterCellType_Taken:
            {
                cell.label.text = NSLocalizedString(@"已取订单", nil);
                break;
            }
            case FilterCellType_Untaken:
            {
                cell.label.text = NSLocalizedString(@"未取订单", nil);
                break;
            }
            default:
                break;
        }
        
        return cell;
    }
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[OrderTableViewCell alloc]init];
    }
    cell.order = [self.orderArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView  == self.filterTableView) {
        self.selectedType = indexPath.row;
        [self.filterView removeFromSuperview];
        
        [self reloadOrderWithType];
    }
}

- (void)reloadOrderWithType
{
    [self.fetchOperation cancel];
    self.fetchOperation = nil;
    [self.orderArray removeAllObjects];
    [self fetchOrders];
}

#pragma mark - order detail table view delegate
- (void)take:(NSDictionary *)coffee
{
    __weak OrderTableViewController *vc = self;
    
    if (self.takeOperation) {
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    self.takeOperation = [HttpRequest takeProductWithUser:[UserInfo sharedInstance].userId coffeeid:[coffee objectForKey:@"coffeeindent"] completionWithSuccess:^{
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Take coffee successfully!", nil)];
        [self takeCoffee:(NSMutableDictionary *)coffee];
        vc.takeOperation = nil;
    } failure:^(int errorCode) {
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
        vc.takeOperation = nil;
    }];
}

- (void)takeCoffee:(NSMutableDictionary *)coffee
{
    for (NSArray *coffeeArr in self.orderArray) {
        if ([coffeeArr containsObject:coffee]) {
            [coffee setObject:[NSString stringWithFormat:@"%d",CoffeeStatus_Taken] forKey:@"statue"];
            NSInteger row = [self.orderArray indexOfObject:coffeeArr];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}

- (void)cancelCoffee:(NSMutableDictionary *)coffee
{
    for (NSArray *coffeeArr in self.orderArray) {
        if ([coffeeArr containsObject:coffee]) {
            [coffee setObject:[NSString stringWithFormat:@"%d",CoffeeStatus_Back] forKey:@"statue"];
            NSInteger row = [self.orderArray indexOfObject:coffeeArr];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)cancel:(NSDictionary*)coffee
{
    __weak OrderTableViewController *vc = self;
    
    if (self.cancelOperation) {
        return;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    self.cancelOperation = [HttpRequest returnProductWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token coffeeid:[coffee objectForKey:@"coffeeindent"] completionWithSuccess:^{
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Cancel successfully!", nil)];
        [self cancelCoffee:(NSMutableDictionary *)coffee];
        vc.cancelOperation = nil;
    } failure:^(int errorCode) {
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
        vc.cancelOperation = nil;
    }];
}

- (void)comment:(NSDictionary *)coffee
{
    CommentViewController *vc = [[UIStoryboard storyboardWithName:@"UserStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"CommentViewController"];
    vc.coffee = coffee;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)feedback:(NSDictionary *)coffee
{
    
}

- (void)location:(NSDictionary *)coffee
{
    float longitude = [[coffee objectForKey:@"longitude"]floatValue];
    float latitude = [[coffee objectForKey:@"latitude"]floatValue];
    [self showMap:CLLocationCoordinate2DMake(longitude, latitude)];
}

- (void)showMap:(CLLocationCoordinate2D)coord
{
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    if (!self.mapBg) {
        
        self.mapBg= [[UIView alloc]initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
        self.mapBg.backgroundColor = [UIColor colorWithRed:10.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:0.5];
        self.map =  [[MKMapView alloc]initWithFrame:CGRectMake(19, 107, 282, self.view.frame.size.height - 43*2)];

        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        btn.center = CGPointMake(self.map.frame.origin.x+self.map.frame.size.width, self.map.frame.origin.y);
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeMap) forControlEvents:UIControlEventTouchUpInside];
        
        [self.mapBg addSubview:self.map];
        [self.mapBg addSubview:btn];
    }
    MKCoordinateRegion region = MKCoordinateRegionMake(coord, MKCoordinateSpanMake(0.05, 0.05));
    self.map.region = region;

    [window addSubview:self.mapBg];
    
    [UIView animateWithDuration:0.8 animations:^{
        [self.mapBg setFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
    }];
}

- (void)closeMap
{
    [self.mapBg removeFromSuperview];
}

- (IBAction)filter:(id)sender {
    if (!self.filterView) {
        
        self.filterView = [[UIView alloc]initWithFrame:CGRectMake(185, 48, 120, 113)];
        [self.filterView addSubview:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_filter"]]];
        
        self.filterTableView = [[UITableView alloc]initWithFrame:CGRectMake(13, 10, 120, 90)];
        [self.filterView addSubview:self.filterTableView];
        
        self.filterView.backgroundColor = [UIColor clearColor];
        self.filterTableView.backgroundColor = [UIColor clearColor];
        
        self.filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.filterTableView.delegate = self;
        self.filterTableView.dataSource = self;
    }
    else {
        [self.filterTableView reloadData];
    }
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:self.filterView];
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
