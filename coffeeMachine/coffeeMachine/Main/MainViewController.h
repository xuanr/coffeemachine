//
//  MainViewController.h
//  coffeeMachine
//
//  Created by Beifei on 5/19/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "CenterViewController.h"
#import "CoffeeMakeView.h"
#import "NearbyCell.h"
#import "LoginViewController.h"
#import "CoffeeCell.h"

@interface MainViewController : CenterViewController<UICollectionViewDataSource,UICollectionViewDelegate,CoffeeMakeViewDelegate,NearbyCellDelegate,LoginDelegate,CoffeeCellDelegate>

- (void)closeCoffeeView;

@end
