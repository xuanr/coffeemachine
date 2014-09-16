//
//  UIViewController+CustomBack.m
//  coffeeMachine
//
//  Created by Beifei on 6/11/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "UIViewController+CustomBack.h"
#import <objc/runtime.h>

@implementation UIViewController (CustomBack)

+(void)load{
    
    Method viewWillAppear = class_getInstanceMethod(self, @selector(customViewWillAppear:));
    
    Method customViewWillAppear = class_getInstanceMethod(self, @selector(viewWillAppear:));
    method_exchangeImplementations(viewWillAppear, customViewWillAppear);
}

-(void)customViewWillAppear:(BOOL)animated{
    [self customViewWillAppear:animated];
    if([self.navigationController.viewControllers indexOfObject:self] != 0  && !self.navigationItem.hidesBackButton){
        UIBarButtonItem *cancelBarButton = nil;
        UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton addTarget:self action:@selector(popViewControllerWithAnimation) forControlEvents:UIControlEventTouchUpInside];
        UIImage *img = [UIImage imageNamed:@"btn_back"];
        [cancelButton setBackgroundImage:img forState:UIControlStateNormal];
        [cancelButton setFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
        
        cancelBarButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
        
        NSMutableArray * leftButtons = [NSMutableArray arrayWithObject:cancelBarButton];
        [leftButtons addObjectsFromArray:self.navigationItem.leftBarButtonItems];
        [self.navigationItem setLeftBarButtonItem:nil];
        [self.navigationItem setLeftBarButtonItems:leftButtons];
    }
    
    [self.navigationItem setHidesBackButton:YES];
}

-(void)popViewControllerWithAnimation{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
