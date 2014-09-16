//
//  GuideViewController.m
//  coffeeMachine
//
//  Created by Beifei on 7/10/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "GuideViewController.h"
#import "GuideView.h"
#import "CoffeeShakeGuideView.h"
#import "AppDelegate.h"

@interface GuideViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) int lastContentOffsetX;

@property (nonatomic, strong) NSArray *textFrameArray;
@property (nonatomic, strong) NSArray *picFrameArray;

@property (nonatomic, strong) NSMutableArray *subViews;
@property (nonatomic, strong) UIButton *start;

@end

@implementation GuideViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.subViews = [NSMutableArray array];
    self.textFrameArray = [NSArray arrayWithObjects:[NSValue valueWithCGRect:CGRectMake(27, 233, 162, 80)],
                           [NSValue valueWithCGRect:CGRectMake(34, 193, 180, 79)],
                           [NSValue valueWithCGRect:CGRectMake(34, 357, 216, 57)],
                           [NSValue valueWithCGRect:CGRectMake(29, 182, 273, 27)],nil];
    
    self.picFrameArray = [NSArray arrayWithObjects:[NSValue valueWithCGRect:CGRectMake(80, 83, 160, 100)],
                           [NSValue valueWithCGRect:CGRectMake(178, 98, 0, 0)],
                           [NSValue valueWithCGRect:CGRectMake(49, 108, 221, 184)],
                           [NSValue valueWithCGRect:CGRectMake(123, 77, 72, 80)],nil];
    
    self.scrollView.pagingEnabled = YES;
    NSInteger height = (RETINA4INCH)?self.scrollView.frame.size.height:self.scrollView.frame.size.height - iPhone5Offset;
    
    CGSize size = CGSizeMake(self.scrollView.frame.size.width * kNumberOfPages, height);
    self.scrollView.contentSize = size;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    [self.scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_slide"]]];
    
    self.lastContentOffsetX = 0;
    
    for (int page = 0; page<kNumberOfPages; page++) {
        GuideView *view = nil;
        if (page == 1) {
            view = [[CoffeeShakeGuideView alloc]initWithNum:page+1];
        }
        else {
            view = [[GuideView alloc] initWithNum:page+1];
        }
        
        CGRect frame;
        [[self.textFrameArray objectAtIndex:page] getValue:&frame];
        [view.labelView setFrame:frame];
        [[self.picFrameArray objectAtIndex:page] getValue:&frame];
        [view.picView setFrame:frame];
        
        frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        view.frame = frame;
        [self.scrollView addSubview:view];
        [self.subViews addObject:view];
        
        if (page == 0) {
            [view beginAnimate];
        }
        
        self.start = [[UIButton alloc]initWithFrame:CGRectMake(160*(kNumberOfPages*2-1)-40, height- 128 , 79, 25)];
        [self.start setBackgroundImage:[UIImage imageNamed:@"guide-s"] forState:UIControlStateNormal];
        [self.start addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:self.start];
    }
}

- (void)start:(id)sender
{
    [(AppDelegate *)[[UIApplication sharedApplication]delegate] changeRoot];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    
    if ((int)point.x % 320 == 0)
    {
        int page = (int)point.x/320;
        
        GuideView *view = [self.subViews objectAtIndex:page];
        [view beginAnimate];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
