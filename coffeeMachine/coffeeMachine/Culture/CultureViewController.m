//
//  CultureViewController.m
//  coffeeMachine
//
//  Created by Beifei on 5/20/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "CultureViewController.h"
#import "CultureViewTableViewCell.h"
#import "CultureDetailViewController.h"

@interface CultureViewController ()

@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) NSOperation *cultureOperation;

@end

@implementation CultureViewController

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
    self.title = NSLocalizedString(@"咖啡文化", nil);
    
    if (self.cultureOperation) {
        return;
    }
    
    NSString *lastId = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastCultureId"];
    if (!lastId) {
        lastId = @"0";
    }
    NSArray *cultureArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"cultures"];
    if (!cultureArr) {
        self.tableData = [NSMutableArray array];
    }
    else {
        self.tableData = [NSMutableArray arrayWithArray:cultureArr];
    }
    
    __weak CultureViewController *vc = self;
    self.cultureOperation = [HttpRequest cultureListWithLastId:lastId type:Culture_Forward completionWithSuccess:^(NSArray *arr) {

        if ([arr count]>0) {
            [vc.tableData insertObjects:arr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [arr count])]];
            [vc.tableView reloadData];
            if ([self.tableData count]>0) {
                [vc.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[vc.tableData count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            vc.cultureOperation = nil;
            [[NSUserDefaults standardUserDefaults]setObject:self.tableData forKey:@"cultures"];
            NSDictionary *dict = [arr objectAtIndex:0];
            NSString *lastId = [dict objectForKey:@"id"];
            if (lastId) {
                [[NSUserDefaults standardUserDefaults]setObject:lastId forKey:@"lastCultureId"];
            }
        }
    } failure:^(int errorCode) {
        vc.cultureOperation = nil;
    }];
    
    if ([self.tableData count]>0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.tableData count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CultureDetailViewController *vc = [segue destinationViewController];
    CultureViewTableViewCell *cell = (CultureViewTableViewCell *)sender;
    
    vc.data = cell.data;
}

#pragma mark-delegate of tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CultureViewTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CultureTableViewCell"];
    cell.data = [self.tableData objectAtIndex:[self.tableData count]-1-indexPath.row];
    
    return cell;
}

@end
