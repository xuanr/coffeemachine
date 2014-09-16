//
//  FavoriteTableViewCell.m
//  coffeeMachine
//
//  Created by Beifei on 6/12/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "FavoriteTableViewCell.h"
#import "CoffeePictureUpdateManager.h"

@interface FavoriteTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *coffeeImg;
@property (weak, nonatomic) IBOutlet UILabel *coffeeName;
@property (weak, nonatomic) IBOutlet UILabel *value;
@property (weak, nonatomic) IBOutlet UILabel *ingredients;
@property (weak, nonatomic) IBOutlet UILabel *buys;
@property (weak, nonatomic) IBOutlet UIButton *comments;

@end

@implementation FavoriteTableViewCell

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
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 79.5, 320, 0.5)];
    line.backgroundColor = SeperatorColor;
    [self addSubview:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFavDict:(NSDictionary *)favDict
{
    _favDict = favDict;
    self.coffeeName.text = [favDict objectForKey:@"title"];
    self.ingredients.text = [favDict objectForKey:@"dosingcontent"];
    self.buys.text = [NSString stringWithFormat:@"%d%@",[[favDict objectForKey:@"salenum"]integerValue],NSLocalizedString(@"buys", nil)];
    NSString *text = [NSString stringWithFormat:@"%d%@",[[favDict objectForKey:@"commentnum"]integerValue],NSLocalizedString(@"comments", nil)];
    [self.comments setTitle:text forState:UIControlStateNormal];
    self.value.text = [NSString stringWithFormat:@"¥ %.2f %@",[[favDict objectForKey:@"price"]doubleValue],NSLocalizedString(@"Yuan", nil)];
    
    UIImage *image = [[CoffeePictureUpdateManager sharedManager]coffeePictureOfId:[favDict objectForKey:@"coffeeid"] atUrl:@""];
    
    if (image) {
        [self.coffeeImg setImage:image];
    }
    else {
        [self.coffeeImg setImage:[UIImage imageNamed:@"icon_small_coffee"]];
        __weak FavoriteTableViewCell *cell = self;
        [[NSNotificationCenter defaultCenter]addObserverForName:CoffeePictureDownloadFinished object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            NSDictionary *info = [note userInfo];
            UIImage *coffeeImg = [info objectForKey:[favDict objectForKey:@"coffeeid"]];
            if (coffeeImg) {
                [cell.coffeeImg setImage:coffeeImg];
            }
            
        }];
    }
}

- (IBAction)comment:(id)sender {
}

- (IBAction)addToCart:(id)sender {
    if (self.delgate && [self.delgate respondsToSelector:@selector(addToCart:)]) {
        [self.delgate addToCart:self.favDict];
    }
}

@end
