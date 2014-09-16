//
//  OrderTableViewCell.m
//  coffeeMachine
//
//  Created by Beifei on 6/20/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "OrderTableViewCell.h"

@interface OrderTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *qty;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (strong, nonatomic) UITableView *orderTableView;
@property (weak, nonatomic) IBOutlet UIView *orderView;
@property (weak, nonatomic) IBOutlet UIView *seperator;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation OrderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    CGRect frame = self.seperator.frame;
    frame.size.height = 0.5;
    [self.seperator setFrame:frame];
    
    self.orderTableView = [[UITableView alloc]initWithFrame:self.orderView.bounds];
    self.orderTableView.delegate = self;
    self.orderTableView.dataSource = self;
    self.orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderTableView.scrollEnabled = NO;
    [self.orderView addSubview:self.orderTableView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrder:(NSArray *)order
{
    _order = order;
    
    if ([order count]>0) {
        NSDictionary *info = [order objectAtIndex:0];
        self.orderNo.text = [info objectForKey:@"indentid"];
        self.qty.text = [info objectForKey:@"count"];
        self.price.text = [info objectForKey:@"totalprice"];
    }
    [self.orderTableView reloadData];
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    CGRect tableFrame = self.orderTableView.frame;
    tableFrame.size.height = ([self.order count]-1)*60;
    [self.orderTableView setFrame:tableFrame];
    
    CGRect orderFrame = self.orderView.frame;
    orderFrame.size.height = tableFrame.size.height;
    [self.orderView setFrame:orderFrame];
    
    CGRect bottomFrame = self.bottomView.frame;
    bottomFrame.origin.y = self.orderView.frame.origin.y+self.orderView.frame.size.height;
    [self.bottomView setFrame:bottomFrame];
}

+ (NSInteger)height:(NSInteger)num
{
    return 71+num*60;
}

#pragma mark - table view delegate/datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.order count]-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailCell"];
    
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"OrderDetailTableViewCell" owner:nil options:nil];
        if ([arr count]>0) {
            cell = [arr objectAtIndex:0];
        }
        else {
            cell = [[OrderDetailTableViewCell alloc]init];
        }
    }
    cell.coffee = [self.order objectAtIndex:indexPath.row+1];
    cell.delegate = self.delegate;
    
    return cell;
}

@end
