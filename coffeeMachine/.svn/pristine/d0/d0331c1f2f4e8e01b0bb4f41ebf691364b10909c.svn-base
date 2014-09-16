//
//  OrderDetailTableViewCell.m
//  coffeeMachine
//
//  Created by Beifei on 6/20/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "OrderDetailTableViewCell.h"
#import "CoffeePictureUpdateManager.h"
#import "Util.h"

@interface OrderDetailTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *coffeeName;
@property (weak, nonatomic) IBOutlet UIImageView *coffeeIcon;
@property (weak, nonatomic) IBOutlet UILabel *coffeeNo;
@property (weak, nonatomic) IBOutlet UILabel *coffeePrice;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *map;

@property (weak, nonatomic) IBOutlet UIView *untakeView;
@property (weak, nonatomic) IBOutlet UIView *takenView;
@property (weak, nonatomic) IBOutlet UIView *cancelView;
@property (weak, nonatomic) IBOutlet UILabel *hasCommentedLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

@implementation OrderDetailTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, self.frame.size.height-0.5, 288, 0.5)];
    line.backgroundColor = SeperatorColor;
    [self.contentView addSubview:line];
}

- (void)setCoffee:(NSDictionary *)coffee
{
    _coffee = coffee;
    CoffeeStatus status = [[coffee objectForKey:@"statue"] integerValue];
    if( status == CoffeeStatus_Untake)
    {
    
        self.takenView.hidden = YES;
        self.untakeView.hidden = NO;
        self.cancelView.hidden = YES;
        
        self.coffeeNo.text = [coffee objectForKey:@"coffeeindent"];
    }
    else if (status == CoffeeStatus_Taken)
    {
        self.takenView.hidden = NO;
        self.untakeView.hidden = YES;
        self.cancelView.hidden = YES;
        
        NSTimeInterval time = [[coffee objectForKey:@"paytime"] doubleValue]/1000;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        self.timeLabel.text = [formatter stringFromDate:date];
        
        if ([coffee objectForKey:@"longitude"]&&[coffee objectForKey:@"latitude"]) {
            self.map.hidden = NO;
        }
        else {
            self.map.hidden = YES;
        }
        
        if ([[coffee objectForKey:@"hasCommented"]isEqualToString:@"true"]) {
            self.hasCommentedLabel.hidden = NO;
            self.commentBtn.hidden = YES;
        }
        else {
            self.hasCommentedLabel.hidden = YES;
            self.commentBtn.hidden = NO;
        }
    }
    else {
        self.takenView.hidden = NO;
        self.untakeView.hidden = NO;
        self.cancelView.hidden = YES;
    }
    
    self.coffeeName.text = [coffee objectForKey:@"title"];
    self.coffeePrice.text = [NSString stringWithFormat:@"¥ %@",[self.coffee objectForKey:@"price"]];
    
    UIImage *image = [[CoffeePictureUpdateManager sharedManager]coffeePictureOfId:[coffee objectForKey:@"coffeeid"] atUrl:@""];
    
    if (image) {
        [self.coffeeIcon setImage:image];
    }
    else {
        [self.coffeeIcon setImage:[UIImage imageNamed:@"icon_small_coffee"]];
        __weak OrderDetailTableViewCell *cell = self;
        [[NSNotificationCenter defaultCenter]addObserverForName:CoffeePictureDownloadFinished object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            NSDictionary *info = [note userInfo];
            UIImage *coffeeImg = [info objectForKey:[coffee objectForKey:@"coffeeid"]];
            if (coffeeImg) {
                [cell.coffeeIcon setImage:coffeeImg];
            }
            
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)takeProduct:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(take:)]) {
        [self.delegate take:self.coffee];
    }
}

- (IBAction)cancel:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancel:)]) {
        [self.delegate cancel:self.coffee];
    }
}

- (IBAction)comment:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(comment:)]) {
        [self.delegate comment:self.coffee];
    }
}

- (IBAction)location:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(location:)]) {
        [self.delegate location:self.coffee];
    }
}

- (IBAction)feedback:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(feedback:)]) {
        [self.delegate feedback:self.coffee];
    }
}


@end
