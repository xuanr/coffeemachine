//
//  ChangeValue.h
//  coffeeMachine
//
//  Created by Beifei on 6/23/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeValueDelegate <NSObject>

- (void)valueChanged:(NSInteger)value;

@end

@interface ChangeValue : UIView <UITextFieldDelegate>

@property (nonatomic, assign) NSInteger value;
@property (weak, nonatomic) id<ChangeValueDelegate> delegate;

@property (nonatomic ,assign) NSInteger minium;
@property (nonatomic, assign) NSInteger maxium;

@end
