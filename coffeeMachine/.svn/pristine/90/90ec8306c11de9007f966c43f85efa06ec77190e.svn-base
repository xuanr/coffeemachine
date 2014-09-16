//
//  CultureViewTableViewCell.m
//  coffeeMachine
//
//  Created by xuanr on 14-7-21.
//  Copyright (c) 2014年 iChuansuo. All rights reserved.
//

#import "CultureViewTableViewCell.h"
#import "PictureDownloadManager.h"
#import "Util.h"

@interface CultureViewTableViewCell()

@property (nonatomic, strong) IBOutlet UIImageView *timeStringBg;
@property (nonatomic, strong) IBOutlet UIImageView *image;
@property (nonatomic, strong) IBOutlet UILabel *label_time;
@property (nonatomic, strong) IBOutlet UILabel *label_introduce;

@end

@implementation CultureViewTableViewCell

- (void)awakeFromNib
{
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    NSString *url = [data objectForKey:@"picurl"];
    if (url) {
        UIImage *img = [[PictureDownloadManager sharedManager]pictureOfUrl:url];
        
        if (img) {
            [self.image setImage:img];
        }
        else {
            __weak CultureViewTableViewCell *cell = self;
            [[NSNotificationCenter defaultCenter]addObserverForName:PictureDownloadFinishedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                
                NSDictionary *info = [note userInfo];
                
                UIImage *img = [info objectForKey:url];
                if (img) {
                    [cell.image setImage:img];
                }
            }];
        }
    }
    
    NSTimeInterval timeInterval = [[data objectForKey:@"time"]doubleValue];
    NSString *timeString = [Util timeString:timeInterval];
    [self.label_time setText:timeString];
    
    UIImage *img = [[UIImage imageNamed:@"img_roundcorner"]stretchableImageWithLeftCapWidth:9 topCapHeight:0];
    [self.timeStringBg setImage:img];
    
    [self.label_introduce setText:[data objectForKey:@"title"]];
    
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    NSTimeInterval timeInterval = [[self.data objectForKey:@"time"]doubleValue];
    NSString *timeString = [Util timeString:timeInterval];
    CGSize size = CGSizeMake(280, 20);
    UIFont *font = [UIFont systemFontOfSize:10];
    if (IOS7) {
        CGRect frame = [timeString boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{UITextAttributeFont: font} context:nil];
        size = frame.size;
    }
    else {
        size = [timeString sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    size.width = size.width+10;
    [self.timeStringBg setFrame:CGRectMake(160-size.width/2, 7, size.width, 20)];
}

@end
