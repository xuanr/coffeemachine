//
//  CartTableViewCell.m
//  coffeeMachine
//
//  Created by Beifei on 6/12/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "CartTableViewCell.h"
#import "CoffeePictureUpdateManager.h"

@interface CartTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *coffeeImg;
@property (weak, nonatomic) IBOutlet UILabel *coffeeName;
@property (weak, nonatomic) IBOutlet UIImageView *checkIcon;
@property (weak, nonatomic) IBOutlet UILabel *ingredientLabel;
@property (weak, nonatomic) IBOutlet UILabel *value;
@property (weak, nonatomic) IBOutlet UILabel *totalValue;
@property (strong, nonatomic) ChangeValue *changeValue;
@property (weak, nonatomic) IBOutlet UILabel *qtyLabel;

@end

@implementation CartTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(39, 65, 261, 0.5)];
    line.backgroundColor = SeperatorColor;
    [self.contentView addSubview:line];
    
    UIView *seperator = [[UIView alloc]initWithFrame:CGRectMake(0, 104.5, 320, 0.5)];
    seperator.backgroundColor = DarkSeperatorColor;
    [self.contentView addSubview:seperator];
    
    self.changeValue = [[ChangeValue alloc]init];
    self.changeValue.delegate = self;
    self.changeValue.maxium = MAX_COFFEE;
    self.changeValue.minium = 1;
    [self.editQtyView addSubview:self.changeValue];
}

- (void)setCart:(NSMutableDictionary *)cart
{
    _cart = cart;
    self.coffeeName.text = [cart objectForKey:@"coffeename"];
    self.value.text = [cart objectForKey:@"price"];
    self.ingredientLabel.text = [cart objectForKey:@"dosingcontent"];
    self.qtyLabel.text = [cart objectForKey:@"num"];
    self.totalValue.text = [NSString stringWithFormat:@"%.2f",[[cart objectForKey:@"price"]doubleValue]*[[cart objectForKey:@"num"]integerValue]];
    self.changeValue.value = [[cart objectForKey:@"num"]integerValue];
    
    UIImage *image = [[CoffeePictureUpdateManager sharedManager]coffeePictureOfId:[cart objectForKey:@"coffeeid"] atUrl:@""];
    
    if (image) {
        [self.coffeeImg setImage:image];
    }
    else {
        [self.coffeeImg setImage:[UIImage imageNamed:@"icon_small_coffee"]];
        __weak CartTableViewCell *cell = self;
        [[NSNotificationCenter defaultCenter]addObserverForName:CoffeePictureDownloadFinished object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            NSDictionary *info = [note userInfo];
            UIImage *coffeeImg = [info objectForKey:[cart objectForKey:@"coffeeid"]];
            if (coffeeImg) {
                [cell.coffeeImg setImage:coffeeImg];
            }
            
        }];
    }
}

- (void)valueChanged:(NSInteger)value
{
    [self.cart setObject:[NSString stringWithFormat:@"%d",value] forKey:@"num"];
    self.totalValue.text = [NSString stringWithFormat:@"%.2f",[[self.cart objectForKey:@"price"]doubleValue]*value];
    [self.delegate cartChange:self.cart];
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected) {
        [self.checkIcon setImage:[UIImage imageNamed:@"btn_select_pressed"]];
    }
    else {
        [self.checkIcon setImage:[UIImage imageNamed:@"btn_select"]];
    }
}

@end
