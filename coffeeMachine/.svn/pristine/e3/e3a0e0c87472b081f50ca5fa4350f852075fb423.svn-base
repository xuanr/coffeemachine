//
//  CoffeeCell.m
//  coffeeMachine
//
//  Created by Beifei on 6/17/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "CoffeeCell.h"
#import "CoffeePictureUpdateManager.h"
#import "Util.h"

@interface CoffeeCell()

@property (weak, nonatomic) IBOutlet UIImageView *coffeeImage;
@property (weak, nonatomic) IBOutlet UILabel *coffeeName;
@property (weak, nonatomic) IBOutlet UILabel *coffeePrice;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

@implementation CoffeeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    if (dict != nil) {
        self.coffeeName.text = [dict objectForKey:@"title"];
        self.coffeePrice.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"price"]];
        
        NSString *commentNum = [dict objectForKey:@"commentnum"];
        if ([commentNum integerValue]>9999) {
            commentNum = @"9999+";
        }
        
        self.commentBtn.titleLabel.text = [NSString stringWithFormat:@"(%@%@)",commentNum,NSLocalizedString(@"comments", nil)];
        
        NSString *buyNum = [dict objectForKey:@"salenum"];
        if ([buyNum integerValue]>9999) {
            buyNum = @"9999+";
        }
        
        self.buyLabel.text = [NSString stringWithFormat:@"%@%@",buyNum,NSLocalizedString(@"buys", nil)];
        
        UIImage *img = nil;
        img = [[CoffeePictureUpdateManager sharedManager]coffeePictureOfId:[dict objectForKey:@"id"] atUrl:[dict objectForKey:@"photo"]];
        
        if (img) {
            [self.coffeeImage setImage:img];
        }
        else {
            [self.coffeeImage setImage:[UIImage imageNamed:@"icon_small_coffee"]];
            __weak CoffeeCell *cell = self;
            [[NSNotificationCenter defaultCenter]addObserverForName:CoffeePictureDownloadFinished object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                NSDictionary *info = [note userInfo];
                UIImage *coffeeImg = [info objectForKey:[dict objectForKey:@"id"]];
                if (coffeeImg) {
                    [cell.coffeeImage setImage:coffeeImg];
                }
                
            }];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)comment:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(comment:)]) {
        [self.delegate comment:self.dict];
    }
}


@end
