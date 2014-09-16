//
//  CartTableViewController.m
//  coffeeMachine
//
//  Created by Beifei on 5/19/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "CartTableViewController.h"
#import "PayViewController.h"

@interface CartTableViewController ()

@property (nonatomic, strong) NSMutableArray *cartArray;
@property (nonatomic, assign) BOOL isContinued;
@property (nonatomic, strong) NSOperation *fetchOperation;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableArray *changedArray;

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL isSeletedAll;
@property (nonatomic, assign) double totalValue;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
@property (weak, nonatomic) IBOutlet UIView *submitView;
@property (weak, nonatomic) IBOutlet UIView *deleteView;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (strong, nonatomic) NSOperation *submitOperation;

@end

@implementation CartTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Cart", nil);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchCarts];
    self.isContinued = YES;
    
    self.cartArray = [NSMutableArray array];
    self.selectedArray = [NSMutableArray array];
    self.changedArray = [NSMutableArray array];
    
    self.isSeletedAll = NO;
    self.isEditing = NO;
}

#pragma mark - scroll
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
                
                [self performSelector:@selector(fetchCarts) withObject:nil afterDelay:0.1f];
            }
        }
    }
}

#pragma mark - fetch orders
- (void)fetchCarts
{
    __weak CartTableViewController *vc = self;
    NSInteger page = [self.cartArray count]/PAGE_ENTRYS+1;
    
    if (self.fetchOperation) {
        return;
    }
    
    self.fetchOperation = [HttpRequest  cartListWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token page:page completionWithSuccess:^(NSArray *array) {
        for (NSMutableDictionary *dict in array) {
            [dict setObject:[dict objectForKey:@"num"] forKey:@"originNum"];
        }
        [vc.cartArray addObjectsFromArray:array];
        [vc.tableView reloadData];
        [vc setupActivityIndicatorView:NO];
        vc.fetchOperation = nil;
    } failure:^(int errorCode) {
        [self setupActivityIndicatorView:NO];
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
        vc.fetchOperation = nil;
    }];
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
        if ([self.cartArray count]%PAGE_ENTRYS==0) {
            return YES;
        }
        else{
            self.isContinued = NO;
        }
    }
    return self.isContinued;
}

#pragma mark - tableviewcell delegate
- (void)cartChange:(NSDictionary *)cart
{
    if ([[cart objectForKey:@"num"]isEqualToString:[cart objectForKey:@"orginNum"]]) {
        if ([self.changedArray containsObject:cart]) {
            [self.changedArray removeObject:cart];
        }
    }
    else {
        if (![self.changedArray containsObject:cart]) {
            [self.changedArray addObject:cart];
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.cartArray count]==0) {
        return 1;
    }
    return [self.cartArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cartArray count]==0) {
        return [tableView dequeueReusableCellWithIdentifier:@"blankCartCell" forIndexPath:indexPath];
    }
    
    CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartCell" forIndexPath:indexPath];
    
    NSMutableDictionary *cart = [self.cartArray objectAtIndex:indexPath.row];
    cell.cart = cart;
    if (self.isEditing) {
        cell.editQtyView.hidden = NO;
    }
    else {
        cell.editQtyView.hidden = YES;
    }
    
    if (self.isSeletedAll) {
        cell.isSelected = YES;
    }
    else {
        if ([self.selectedArray containsObject:cart]) {
            cell.isSelected = YES;
        }
        else {
            cell.isSelected = NO;
        }
    }
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cartArray count]==0) {
        return;
    }
    CartTableViewCell *cell = (CartTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *cart = [self.cartArray objectAtIndex:indexPath.row];
    
    cell.isSelected = !cell.isSelected;
    if (cell.isSelected) {
        [self.selectedArray addObject:cart];
        if ([self.selectedArray count]==[self.cartArray count]) {
            self.isSeletedAll = YES;
        }
    }
    else {
        [self.selectedArray removeObject:cart];
        if (self.isSeletedAll) {
            self.isSeletedAll = NO;
        }
    }
    [self calculateTotalValue];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if ([self.cartArray count]==0) {
        return NO;
    }
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSDictionary *dict = [self.cartArray objectAtIndex:indexPath.row];
        [self deleteCart:dict];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - action
- (void)edit
{
    self.isEditing = YES;
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
}

- (void)done
{
    self.isEditing = NO;
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    
    if ([self.changedArray count]==0) {
        return;
    }
    
    __weak CartTableViewController *vc = self;
    
    NSMutableString *content = [NSMutableString stringWithString:@""];
    NSMutableString *num = [NSMutableString stringWithString:@""];
    for (int i = 0;i<[self.changedArray count];i++) {
        NSDictionary *dict = [self.changedArray objectAtIndex:i];
        [content appendString:[NSString stringWithFormat:@"%@A%@",[dict objectForKey:@"coffeeid"],[dict objectForKey:@"dosing"]]];
        [num appendString:[dict objectForKey:@"num"]];
        if (i+1<[self.changedArray count]) {
            [content appendString:@"P"];
            [num appendString:@"_"];
        }
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    self.submitOperation = [HttpRequest modifyCartWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token coffee:content coffeeNum:num completionWithSuccess:^{
        [SVProgressHUD dismiss];
        for (NSMutableDictionary *dict in vc.changedArray) {
            [dict setObject:[dict objectForKey:@"num"] forKey:@"orginNum"];
        }
        [vc.changedArray removeAllObjects];
    } failure:^(int errorCode) {
        NSMutableArray *indexArray = [NSMutableArray array];
        for (NSMutableDictionary *dict in vc.changedArray) {
            [dict setObject:[dict objectForKey:@"originNum"] forKey:@"num"];
            NSInteger index = [vc.cartArray indexOfObject:dict];
            if (index != NSNotFound) {
                [indexArray addObject:[NSIndexPath indexPathWithIndex:index]];
            }
        }
        
        [vc.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
        
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
        [vc.changedArray removeAllObjects];
    }];
}

- (void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    self.submitView.hidden = isEditing;
    self.deleteView.hidden = !isEditing;
}

- (IBAction)submit:(id)sender {
    if (self.submitOperation) {
        return;
    }
    
    __weak CartTableViewController *vc = self;
    
    NSMutableString *content = [NSMutableString stringWithString:@""];
    NSMutableString *dosing = [NSMutableString stringWithString:@""];
    for (int i = 0;i<[self.selectedArray count];i++) {
        NSDictionary *dict = [self.selectedArray objectAtIndex:i];
        [content appendString:[NSString stringWithFormat:@"%@C%@",[dict objectForKey:@"coffeeid"],[dict objectForKey:@"num"]]];
        [dosing appendString:[dict objectForKey:@"dosing"]];
        if (i+1<[self.selectedArray count]) {
            [content appendString:@"_"];
            [dosing appendString:@"P"];
        }
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    self.submitOperation = [HttpRequest submitOrderWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token content:content dosing:dosing source:OrderSource_Cart completionWithSuccess:^(NSArray *arr, NSArray *coffeeArray,NSString *orderId){
        vc.submitOperation = nil;
        [SVProgressHUD dismiss];
        
        PayViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"PayViewController"];
        vc.valueArr = arr;
        vc.coffeeArr = coffeeArray;
        vc.indent = orderId;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(int errorCode) {
        vc.submitOperation = nil;
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)deleteCart:(NSDictionary *)cart
{
    NSString *content = [NSString stringWithFormat:@"%@A%@",[cart objectForKey:@"coffeeid"],[cart objectForKey:@"dosing"]];
    
    __weak CartTableViewController *vc = self;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [HttpRequest removeFromCartWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token coffee:content completionWithSuccess:^{
        [SVProgressHUD dismiss];
        
        NSInteger index = [vc.cartArray indexOfObject:cart];
        if (index >= 0) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
            [vc.cartArray removeObject:cart];
            [vc.changedArray removeObject:cart];
            [vc.selectedArray removeObject:cart];
            
            if ([vc.cartArray count] == 0) {
                [vc.tableView reloadData];
            }
            else
            {
                [vc.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        
    } failure:^(int errorCode) {
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (IBAction)delete:(id)sender {
    
    NSMutableString *content = [NSMutableString stringWithString:@""];
    for (int i = 0;i<[self.selectedArray count];i++) {
        NSDictionary *dict = [self.selectedArray objectAtIndex:i];
        [content appendString:[NSString stringWithFormat:@"%@A%@",[dict objectForKey:@"coffeeid"],[dict objectForKey:@"dosing"]]];
        
        if (i+1<[self.selectedArray count]) {
            [content appendString:@"P"];;
        }
    }
    
    __weak CartTableViewController *vc = self;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    [HttpRequest removeFromCartWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token coffee:content completionWithSuccess:^{
        [SVProgressHUD dismiss];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in vc.selectedArray) {
            NSInteger index = [vc.cartArray indexOfObject:dict];
            NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
            [arr addObject:path];
        }
        
        [vc.cartArray removeObjectsInArray:self.selectedArray];
        [vc.changedArray removeObjectsInArray:self.selectedArray];
        [vc.selectedArray removeAllObjects];
        if ([self.cartArray count]==0) {
            [vc.tableView reloadData];
        }
        else {
            [vc.tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
        }
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

- (void)calculateTotalValue
{
    self.totalValue = 0;
    for (NSDictionary *dict in self.selectedArray) {
        self.totalValue+=[[dict objectForKey:@"price"]doubleValue] * [[dict objectForKey:@"num"]integerValue];
    }
    self.totalValueLabel.text = [NSString stringWithFormat:@"%.2f",self.totalValue];
    
    [self resetValueComponents];
}

- (void)resetValueComponents
{
    if ([self.selectedArray count]>0) {
        self.totalLabel.textColor = [UIColor redColor];
        self.totalValueLabel.textColor = [UIColor redColor];
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_red_delete"] forState:UIControlStateNormal];
    }
    else {
        self.totalLabel.textColor = [UIColor darkGrayColor];
        self.totalValueLabel.textColor = [UIColor darkGrayColor];
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_gray_submit"] forState:UIControlStateNormal];
    }
}

- (void)setIsSeletedAll:(BOOL)isSeletedAll
{
    _isSeletedAll = isSeletedAll;
    if (isSeletedAll) {
        [self.selectAllBtn setImage:[UIImage imageNamed:@"btn_select_pressed"] forState:UIControlStateNormal];
    }
    else {
        [self.selectAllBtn setImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
    }
}

- (IBAction)selectAllBtn:(id)sender {
    self.isSeletedAll = !self.isSeletedAll;
    [self.tableView reloadData];
    
    [self.selectedArray removeAllObjects];
    if (self.isSeletedAll) {
        [self.selectedArray addObjectsFromArray:self.cartArray];
    }
    [self calculateTotalValue];
}
@end
