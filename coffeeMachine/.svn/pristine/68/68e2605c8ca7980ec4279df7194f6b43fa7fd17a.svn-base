//
//  NearbyCell.m
//  coffeeMachine
//
//  Created by Beifei on 6/19/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "NearbyCell.h"

@implementation NearbyCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.avatar = [[AvatarImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        [self.avatar setImage:[UIImage imageNamed:@"icon_avatar_main"]];
        [self.avatar addTarget:self action:@selector(selectUser) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.avatar];
        self.userName = [[UILabel alloc]initWithFrame:CGRectMake(0, 66, 60, 11)];
        self.userName.text = @"zhangsan";
        self.userName.textAlignment = NSTextAlignmentCenter;
        self.userName.textColor = [UIColor darkGrayColor];
        self.userName.font = [UIFont systemFontOfSize:9.0];
        self.userName.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.userName];
    }
    return self;
}

- (void)selectUser
{
    [self.delegate selectUser];
}

@end
