//
//  PersonalCityTableViewController.h
//  coffeeMachine
//
//  Created by Beifei on 6/6/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCityTableViewController : UITableViewController

@property (strong, nonatomic) NSString *state;

- (id)initWithCities:(NSArray *)cities;

@end
