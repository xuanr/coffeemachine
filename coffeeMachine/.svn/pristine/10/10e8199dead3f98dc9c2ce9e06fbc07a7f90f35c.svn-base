//
//  SuggestionViewController.m
//  coffeeMachine
//
//  Created by xuanr on 14-7-30.
//  Copyright (c) 2014年 iChuansuo. All rights reserved.
//

#import "SuggestionViewController.h"

@interface SuggestionViewController ()

@end

@implementation SuggestionViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0  blue:230/255.0  alpha:1];
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"提交" forState:0];
    [btn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0, 0, 50, 50)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    self.textfield.delegate = self;
    self.title = NSLocalizedString(@"意见反馈", nil);
    
    [self.textfield becomeFirstResponder];
    
}

-(IBAction)submit:(id)sender
{
    NSLog(@"submit is called");
//    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"感谢您的反馈", nil)];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - delegate of textview
-(void)textViewDidChange:(UITextView *)textView
{
//    if ([textView.text length] == 0) {
//        textView.text = @"您的反馈将帮助我们更快成长";
//        
//    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
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
