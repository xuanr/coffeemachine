//
//  CoffeeMapTableViewCell.m
//  coffeeMachine
//
//  Created by Beifei on 7/31/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "CoffeeMapTableViewCell.h"
#import "Util.h"

@interface CoffeeMapTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *no;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@end

@implementation CoffeeMapTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [self initUI];
}

+ (CoffeeMapTableViewCell*)getInstanceWithNibWithBlock
{
    CoffeeMapTableViewCell *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"CoffeeMapTableViewCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[CoffeeMapTableViewCell class]]){
            
            cell = (CoffeeMapTableViewCell *)obj;
            break;
        }
    }
    
    return cell;
}

-(void)initUI
{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, self.frame.size.height - 0.5, 230, 0.5)];
    line.backgroundColor = SeperatorColor;
    [self.contentView addSubview:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    NSDictionary *dict = [data objectForKey:@"info"];
    self.no.text = [NSString stringWithFormat:@"No.%@",[dict objectForKey:@"machineid"]];
    self.address.text = [dict objectForKey:@"address"];
    self.distance.text = [Util distanceString:[[data objectForKey:@"distance"]doubleValue]];
    
    [self setNeedsDisplay];
}

@end
