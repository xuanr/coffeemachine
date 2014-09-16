//
//  CommentTableViewCell.h
//  coffeeMachine
//
//  Created by Beifei on 6/19/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentTableViewCellDelegate <NSObject>

- (void)viewOriginalAtIndex:(NSInteger)index OfComments:(NSDictionary *)dict;

@end


@interface CommentTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *commentDict;

@property (nonatomic, assign) id<CommentTableViewCellDelegate> delegate;

+ (NSInteger)height:(NSDictionary *)commentDict;

@end
