//
//  CommentTableViewCell.m
//  coffeeMachine
//
//  Created by Beifei on 6/19/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "NSString+Util.h"
#import "PictureDownloadManager.h"
#import "UIImage+Utilities.h"

@interface CommentTableViewCell()

@property (nonatomic, strong) UIView *line;

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (nonatomic, strong) NSMutableArray *imgArr;

@end

@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = CellBgColor;
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, 320, 0.5)];
    self.line.backgroundColor = SeperatorColor;
    [self.contentView addSubview:self.line];
    self.imgArr = [NSMutableArray array];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentDict:(NSDictionary *)commentDict
{
    _commentDict = commentDict;
    NSString *commentStr = [commentDict objectForKey:@"comment"];
    self.comment.text = commentStr;
    self.userName.text = [commentDict objectForKey:@"username"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[commentDict objectForKey:@"time"]doubleValue]/1000];
    self.date.text = [formatter stringFromDate:date];
    
    UIImage *avatar = [[PictureDownloadManager sharedManager]pictureOfUrl:[commentDict objectForKey:@"photo"]];
    
    if (avatar) {
        [self.userIcon setImage:avatar];
    }
    else {
        __weak CommentTableViewCell *cell = self;
        [[NSNotificationCenter defaultCenter]addObserverForName:PictureDownloadFinishedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            
            NSDictionary *info = [note userInfo];
            
            UIImage *img = [info objectForKey:[commentDict objectForKey:@"photo"]];
            if (img) {
                [cell.userIcon setImage:img];
            }
        }];
    }

    for (UIButton *view in self.imgArr) {
        [view removeFromSuperview];
    }
    [self.imgArr removeAllObjects];
    
    NSArray *arr = [commentDict objectForKey:@"smallCommentpicList"];
    if ([arr count]>0) {
        for (int i = 0;i<[arr count];i++) {
            NSString *url = [arr objectAtIndex:i];
            UIImage *commentPic = [[PictureDownloadManager sharedManager]pictureOfUrl:url];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor redColor];
            [btn addTarget:self action:@selector(viewOriginal:) forControlEvents:UIControlEventTouchUpInside];
    
            [self.imgArr addObject:btn];
            if (commentPic) {
                UIImage *img = nil;
                
                if (RETINA) {
                    img = [commentPic thumbnailOfSize:CGSizeMake(80, 80)];
                }
                else {
                    img = [commentPic thumbnailOfSize:CGSizeMake(40, 40)];
                }
                [btn setBackgroundImage:img forState:UIControlStateNormal];
                
            }
            else {
                [[NSNotificationCenter defaultCenter]addObserverForName:PictureDownloadFinishedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                    
                    NSDictionary *info = [note userInfo];
                    
                    UIImage *img = [info objectForKey:url];
                    if (img) {
                        
                        if (RETINA) {
                            img = [img thumbnailOfSize:CGSizeMake(80, 80)];
                        }
                        else {
                            img = [img thumbnailOfSize:CGSizeMake(40, 40)];
                        }
                        [btn setBackgroundImage:img forState:UIControlStateNormal];
                    }
                }];
            }
            [self addSubview:btn];
        }
    }
    
    [self setNeedsDisplay];
}

- (IBAction)viewOriginal:(id)sender
{
    NSLog(@"%@",sender);
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewOriginalAtIndex: OfComments:)]) {
        [self.delegate viewOriginalAtIndex:btn.tag OfComments:self.commentDict];
    }
}

- (void)layoutSubviews
{
    NSString *commentStr = self.comment.text;
    CGSize size = CGSizeZero;
    if (![commentStr isEmpty]) {
        size = CGSizeMake(227, 1000);
        UIFont *font = [UIFont systemFontOfSize:12];
        
        if (IOS7) {
            CGRect frame = [commentStr boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{UITextAttributeFont: font} context:nil];
            size = frame.size;
        }
        else {
            size = [commentStr sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        }
    }
    
    [self.comment setFrame:CGRectMake(self.comment.frame.origin.x, self.comment.frame.origin.y, size.width, size.height)];
    
    NSInteger y = self.comment.frame.origin.y + self.comment.frame.size.height;
    
    if ([[self.commentDict objectForKey:@"smallCommentpicList"]count]>0) {
        y += 6;
        for (int i = 0;i<[self.imgArr count];i++) {
            UIButton *btn = [self.imgArr objectAtIndex:i];
            [btn setFrame:CGRectMake(self.comment.frame.origin.x + i*(5+40), y, 40, 40)];
        }
        y += (40+8);
    }
    else {
        y += 10;
    }
    
    CGRect dateFrame = self.date.frame;
    dateFrame.origin.y = y;
    [self.date setFrame:dateFrame];
    
    [self.line setFrame:CGRectMake(0, self.frame.size.height - 1, 320, 0.5)];
}

+ (NSInteger)height:(NSDictionary *)commentDict
{
    NSInteger height = 34;
    //comment
    NSString *commentStr = [commentDict objectForKey:@"comment"];
    if (![commentStr isEmpty]) {
        CGSize size = CGSizeMake(227, 1000);
        UIFont *font = [UIFont systemFontOfSize:12];
        
        if (IOS7) {
            CGRect frame = [commentStr boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{UITextAttributeFont: font} context:nil];
            size = frame.size;
        }
        else {
            size = [commentStr sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        }
        height+=size.height;
    }
    
    if ([[commentDict objectForKey:@"smallCommentpicList"]count]==0) {
        height+=10;
    }
    else {
        height+=6+8+40;
    }
    
    //date
    height+=8+8;
    return height;
}

@end
