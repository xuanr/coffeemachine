//
//  CoffeeMakeView.m
//  coffeeMachine
//
//  Created by Beifei on 6/18/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "CoffeeMakeView.h"
#import "Util.h"
#import "CoffeePictureUpdateManager.h"

@interface IngredientCell : UITableViewCell<ChangeValueDelegate>

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIView *value;
@property (nonatomic, retain) IBOutlet UILabel *detailLabel;

@property (nonatomic, retain) UIView *line;
@property (nonatomic, retain) UIView *completeLine;
@property (nonatomic, retain) ChangeValue *changeValueView;

@property (nonatomic, weak) id<IndgredientCellDelegate> delegate;

- (void)addSeperatorLine;
- (void)addCompleteSeperatorLine;

@end

@implementation IngredientCell

- (void)addSeperatorLine
{
    [self.completeLine removeFromSuperview];
    [self.line removeFromSuperview];
    self.line = [[UIView alloc]initWithFrame:CGRectMake(16, self.frame.size.height - 0.5, 278, 0.5)];
    self.line.backgroundColor = SeperatorColor;
    [self.contentView addSubview:self.line];
}

- (void)addCompleteSeperatorLine
{
    [self.completeLine removeFromSuperview];
    [self.line removeFromSuperview];
    self.completeLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, 320, 0.5)];
    self.completeLine.backgroundColor = SeperatorColor;
    [self.contentView addSubview:self.completeLine];
}

- (void)awakeFromNib
{
    self.changeValueView = [[ChangeValue alloc]init];
    self.changeValueView.delegate = self;
    [self.value addSubview:self.changeValueView];
}

- (void)valueChanged:(NSInteger)value
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(valueChanged:ofSender:)]) {
        [self.delegate valueChanged:value ofSender:self];
    }
}

@end

@interface CoffeeMakeView()

@property (weak, nonatomic) IBOutlet UIImageView *coffeeImage;
@property (weak, nonatomic) IBOutlet UILabel *coffeeName;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *favBtn;

@property (nonatomic, strong) NSString *coffeeId;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSArray *dosingArr;
@property (nonatomic, strong) NSMutableArray *amountArr;
@property (strong, nonatomic) NSOperation *dossingOperation;

@end

@implementation CoffeeMakeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setData:(NSDictionary *)data
{
    _data = data;
    self.coffeeName.text= [data objectForKey:@"title"];
    self.commentsLabel.text = [NSString stringWithFormat:@"%@ %@",[data objectForKey:@"commentnum"],NSLocalizedString(@"comments", nil)];
    self.buyLabel.text = [NSString stringWithFormat:@"%@%@",[data objectForKey:@"salenum"],NSLocalizedString(@"buys", nil)];
    self.price = [data objectForKey:@"price"];
    self.coffeeId = [data objectForKey:@"id"];
    
    UIImage *img = [[CoffeePictureUpdateManager sharedManager]coffeePictureOfId:[data objectForKey:@"id"] atUrl:[data objectForKey:@"photo"]];
    
    if (img) {
        [self.coffeeImage setImage:img];
    }
    else {
        [self.coffeeImage setImage:[UIImage imageNamed:@"icon_small_coffee"]];
        __weak CoffeeMakeView *view = self;
        [[NSNotificationCenter defaultCenter]addObserverForName:CoffeePictureDownloadFinished object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            NSDictionary *info = [note userInfo];
            UIImage *coffeeImg = [info objectForKey:self.coffeeId];
            if (coffeeImg) {
                [view.coffeeImage setImage:coffeeImg];
            }
            
        }];
    }
    
    if ([[data objectForKey:@"type"]isEqualToString:@"false"]) {
        return;
    }
    
    if (self.dossingOperation) {
        return;
    }
    
    __weak CoffeeMakeView *view = self;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    self.dossingOperation = [HttpRequest dossingCompletionWithSuccess:^(NSArray *dosingArr) {
        [SVProgressHUD dismiss];
        view.dosingArr = dosingArr;
        [view.tableView reloadData];
        [view checkFavBtn];
        view.amountArr = [NSMutableArray array];
        for (int i = 0; i < [dosingArr count]; i++) {
            [view.amountArr addObject:[NSNumber numberWithInt:0]];
        }
        [view.amountArr addObject:[NSNumber numberWithInt:1]];
    } failure:^(int errorCode) {
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
    }];

}

- (void)awakeFromNib
{
    CGRect frame = self.line.frame;
    frame.size.height = 0.5;
    [self.line setFrame:frame];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dosingArr count]+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IngredientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ingredientCell"];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"IngredientCell" owner:nil options:nil];
        if ([arr count]>0) {
            cell = [arr objectAtIndex:0];
        }
    }
    
    if (indexPath.row == [self.dosingArr count]+1) {
        cell.value.hidden = YES;
        cell.label.textColor = [UIColor redColor];
        cell.detailLabel.textColor = [UIColor redColor];
        
        cell.detailLabel.text = [NSString stringWithFormat:@"¥%@",self.price];
        cell.label.text = NSLocalizedString(@"Total", nil);
    }
    else {
        cell.value.hidden = NO;
        cell.label.textColor = [UIColor blackColor];
        
        if (indexPath.row == [self.dosingArr count]) {
            cell.label.text = NSLocalizedString(@"Qty.", nil);
            cell.changeValueView.maxium = MAX_COFFEE;
            cell.changeValueView.minium = 1;
        }
        else {
            NSDictionary *dict = [self.dosingArr objectAtIndex:indexPath.row];
            cell.label.text = [dict objectForKey:@"title"];
            cell.changeValueView.maxium = [[dict objectForKey:@"maximum"]intValue];
        }
        
        cell.changeValueView.value = [[self.amountArr objectAtIndex:indexPath.row]intValue];
    }
    
    if (indexPath.row == [self.dosingArr count]-1) {
        [cell addCompleteSeperatorLine];
    }
    else {
        [cell addSeperatorLine];
    }
    cell.delegate = self;
    
    return cell;
}

- (void)valueChanged:(NSInteger)value ofSender:(id)sender
{
    IngredientCell *cell = (IngredientCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    int index = indexPath.row;    
    [self.amountArr replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:value]];
    
    [self checkFavBtn];
}

#pragma mark - action
- (IBAction)close:(id)sender {
    [self.delegate close];
}

- (IBAction)fav:(id)sender {
    __weak CoffeeMakeView *view = self;
    [self.delegate addToFav:self.coffeeId dosing:[self dosing] completionWithSuccess:^{
        
        [view.favBtn setImage:[UIImage imageNamed:@"btn_fav_pressed"] forState:UIControlStateNormal];
        view.favBtn.enabled = NO;
    } failure:^() {
        
    }];
}

- (IBAction)addToCart:(id)sender
{
    [self.delegate addToCart:self.coffeeId dosing:[self dosing] num:[[self.amountArr objectAtIndex:[self.dosingArr count]]intValue]];
}

- (IBAction)buyContent:(id)sender
{
    NSString *content = [NSString stringWithFormat:@"%@C%d",self.coffeeId,[[self.amountArr objectAtIndex:[self.dosingArr count]]intValue]];
    [self.delegate buyContent:content dosing:[self dosing] coffee:self.data];
}

- (void)checkFavBtn
{
    if ([[UserInfo sharedInstance]checkHasFavWithCoffeeId:[self.data objectForKey:@"id"] dosing:[self dosing]]) {
        [self.favBtn setImage:[UIImage imageNamed:@"btn_fav_pressed"] forState:UIControlStateNormal];
        self.favBtn.enabled = NO;
    }
    else {
        [self.favBtn setImage:[UIImage imageNamed:@"btn_fav"] forState:UIControlStateNormal];
        self.favBtn.enabled = YES;
    }
}

- (NSString *)dosing
{
    NSMutableString *dosing = [NSMutableString stringWithString:@""];
    for (int i = 0; i < [self.dosingArr count]; i++) {
        NSDictionary *dict = [self.dosingArr objectAtIndex:i];
        NSString *ide = [dict objectForKey:@"dosingid"];
        
        int count = [[self.amountArr objectAtIndex:i]intValue];
        if (count>0) {
            if ([dosing length]>0) {
                [dosing appendString:@"_"];
            }
            [dosing appendString:[NSString stringWithFormat:@"%@C%d",ide,count]];
        }
    }
    if ([dosing isEqualToString:@""]) {
        [dosing appendString:@"none"];
    }
    return dosing;
}

@end
