//
//  ChangeValue.m
//  coffeeMachine
//
//  Created by Beifei on 6/23/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "ChangeValue.h"

@interface ChangeValue ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ChangeValue

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"ChangeValue" owner:nil options:nil];
    if ([arr count]>0) {
        self = [arr objectAtIndex:0];
    }
    
    if (self) {
        UIToolbar *toolbar =  [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        item.tintColor = BrownColor;
        toolbar.items = [NSArray arrayWithObjects:btnSpace,item, nil];
        self.textField.inputAccessoryView = toolbar;
        
        self.minium = 0;
        self.maxium = 5;
        self.value = 0;
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setValue:(NSInteger)value
{
    _value = value;
    [self.textField setText:[NSString stringWithFormat:@"%d",value]];
}

#pragma mark - action
- (void)done {
    [self.textField resignFirstResponder];
}

- (IBAction)minus:(id)sender {
    if (self.value - 1 < self.minium) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Exceed limit", nil)];
        return;
    }
    self.value --;
    if (self.delegate && [self.delegate respondsToSelector:@selector(valueChanged:)]) {
        [self.delegate valueChanged:self.value];
    }
}

- (IBAction)plus:(id)sender {
    if (self.value + 1 > self.maxium) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Exceed limit", nil)];
        return;
    }
    self.value ++;
    if (self.delegate && [self.delegate respondsToSelector:@selector(valueChanged:)]) {
        [self.delegate valueChanged:self.value];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

@end
