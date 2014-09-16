//
//  RecordTableViewController.m
//  coffeeMachine
//
//  Created by Beifei on 5/23/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "RecordTableViewController.h"
#import "CustomTableViewCell.h"

typedef enum
{
    TradeValue_ID,
    TradeValue_Money,
    TradeValue_Date
} TradeValue;

@interface AccountCell : CustomTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *recordDetail;
@property (weak, nonatomic) IBOutlet UILabel *recordTime;

@end

@implementation AccountCell

@end

@interface RecordTableViewController ()

@property (nonatomic, strong) NSMutableArray *tradeArr;
@property (nonatomic, assign) BOOL isContinued;

@property (nonatomic, strong) NSOperation *fectchOperation;

@end

@implementation RecordTableViewController

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
    self.title = NSLocalizedString(@"Record", nil);
    self.tradeArr = [NSMutableArray array];
    [self fetchTrades];
    self.isContinued = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchTrades
{
    __weak RecordTableViewController *vc = self;
    NSInteger page = [self.tradeArr count]/PAGE_ENTRYS+1;
    
    if (self.fectchOperation) {
        return;
    }
    
    self.fectchOperation = [HttpRequest tradeWithUser:[UserInfo sharedInstance].userId token:[UserInfo sharedInstance].token page:page completionWithSuccess:^(NSArray *array) {
        [vc.tradeArr addObjectsFromArray:array];
        [vc.tableView reloadData];
        [self setupActivityIndicatorView:NO];
        self.fectchOperation = nil;
    } failure:^(int errorCode) {
        [self setupActivityIndicatorView:NO];
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
        self.fectchOperation = nil;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tradeArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSArray *value = self.tradeArr[row];
    
    double amount = [value[TradeValue_Money] doubleValue];
    
    AccountCell *cell = nil;
    if (amount > 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"accountInCell"];
        cell.recordDetail.text = [NSString stringWithFormat:@"+%.2f(%@)",amount,NSLocalizedString(@"Recharge", nil)];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"accountOutCell"];
        cell.recordDetail.text = [NSString stringWithFormat:@"%.2f(%@)",amount,NSLocalizedString(@"Consume", nil)];
    }
    
    NSTimeInterval time = [value[TradeValue_Date]doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    cell.recordTime.text = [formatter stringFromDate:date];
    
    return cell;
}

#pragma mark - TableView scroll

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
                [self performSelector:@selector(fetchTrades) withObject:nil afterDelay:0.1f];
            }
        }
    }
}

#pragma mark - action
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
        if ([self.tradeArr count]%PAGE_ENTRYS==0) {
            return YES;
        }
        else{
            self.isContinued = NO;
        }
    }
    return self.isContinued;
}

@end
