//
//  CustomPreviewController.m
//  coffeeMachine
//
//  Created by Beifei on 7/18/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "CustomPreviewController.h"

@interface CustomPreviewController ()

@property (strong, nonatomic) QLPreviewController *vc;

@end

@implementation CustomPreviewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.vc = [[QLPreviewController alloc]init];
    self.vc.dataSource = self.dataSource;
    self.vc.delegate = self.delegate;
    self.vc.currentPreviewItemIndex  = self.currentPreviewItemIndex;
    
    [self addChildViewController:self.vc];
    [self.view addSubview:self.vc.view];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"删除", nil) style:UIBarButtonItemStylePlain target:self action:@selector(delete:)];
}

- (void)delete:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteAtIndex:)]) {
        [self.delegate deleteAtIndex:self.vc.currentPreviewItemIndex];
    }
    [self.vc reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
