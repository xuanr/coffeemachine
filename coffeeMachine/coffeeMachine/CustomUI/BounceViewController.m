//
//  BounceViewController.m
//  coffeeMachine
//
//  Created by Beifei on 5/22/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "BounceViewController.h"

@interface BounceViewController ()

@property (weak, nonatomic) IBOutlet UIView *bounceView;
@property (weak, nonatomic) IBOutlet UIView *offsetView;
@property (assign, nonatomic) CGRect orginFrame;

@end

@implementation BounceViewController

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
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
}

- (void)dealloc
{    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - notification
- (void)keyboardWillShow:(NSNotification *)info
{
    self.orginFrame = self.bounceView.frame;
    NSDictionary* userInfo = [info userInfo];
    
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect viewFrame = self.orginFrame;
    viewFrame.origin.y = self.view.frame.size.height - keyboardSize.height - self.offsetView.frame.size.height;
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.bounceView setFrame:viewFrame];
    }];
}

- (void)keyboardWillHide:(NSNotification *)info
{
    [UIView animateWithDuration:0.1 animations:^{
        [self.bounceView setFrame:self.orginFrame];
    }];
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
