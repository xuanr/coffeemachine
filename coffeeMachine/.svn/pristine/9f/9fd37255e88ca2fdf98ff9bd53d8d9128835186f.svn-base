//
//  CommentsTableViewController.m
//  coffeeMachine
//
//  Created by Beifei on 6/18/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "CommentsTableViewController.h"
#import "CommentTableViewCell.h"
#import "CoffeePictureUpdateManager.h"

@interface CommentsTableViewController ()

@property (nonatomic, assign) BOOL isContinued;

@property (weak, nonatomic) IBOutlet UIImageView *coffeeImage;
@property (weak, nonatomic) IBOutlet UILabel *coffeeName;
@property (weak, nonatomic) IBOutlet UILabel *buys;
@property (weak, nonatomic) IBOutlet UILabel *comments;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (nonatomic, strong) NSMutableArray *commentsArray;
@property (nonatomic, strong) NSOperation *fetchOperation;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end

@implementation CommentsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Coffee Comments", nil);
    
    self.coffeeName.text = [self.coffee objectForKey:@"title"];
    self.buys.text = [NSString stringWithFormat:@"%@%@",[self.coffee objectForKey:@"salenum"],NSLocalizedString(@"buys", nil)];
    self.comments.text = [NSString stringWithFormat:@"%@%@",[self.coffee objectForKey:@"commentnum"],NSLocalizedString(@"comments", nil)];
    self.price.text = [NSString stringWithFormat:@"¥%.2f%@",[[self.coffee objectForKey:@"price"]floatValue],NSLocalizedString(@"Yuan", nil)];
    
    UIImage *img = [[CoffeePictureUpdateManager sharedManager]coffeePictureOfId:[self.coffee objectForKey:@"id"] atUrl:[self.coffee objectForKey:@"photo"]];
    if (img) {
        [self.coffeeImage setImage:img];
    }
    else {
        [self.coffeeImage setImage:[UIImage imageNamed:@"icon_small_coffee"]];
        __weak CommentsTableViewController *vc = self;
        [[NSNotificationCenter defaultCenter]addObserverForName:CoffeePictureDownloadFinished object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            NSDictionary *info = [note userInfo];
            UIImage *coffeeImg = [info objectForKey:[vc.coffee objectForKey:@"id"]];
            if (coffeeImg) {
                [vc.coffeeImage setImage:coffeeImg];
            }
            
        }];
    }
    
    self.photos = [NSMutableArray array];
	self.thumbs = [NSMutableArray array];
    self.commentsArray = [NSMutableArray array];
    [self fetchOrders];
}

#pragma mark - fetch orders
- (void)fetchOrders
{
    __weak CommentsTableViewController *vc = self;
    NSInteger page = [self.commentsArray count]/PAGE_ENTRYS+1;
    
    if (self.fetchOperation) {
        return;
    }
    
    self.fetchOperation = [HttpRequest commentListWithCoffeeId:[self.coffee objectForKey:@"id"] page:page completionWithSuccess:^(NSArray *array) {
        [vc.commentsArray addObjectsFromArray:array];
        [vc.tableView reloadData];
        [vc setupActivityIndicatorView:NO];
        vc.fetchOperation = nil;
    } failure:^(int errorCode) {
        [vc setupActivityIndicatorView:NO];
        NSString *msg = [HttpRequest errorMsg:errorCode];
        [SVProgressHUD showErrorWithStatus:msg];
        vc.fetchOperation = nil;
    }];
}

- (void)setupActivityIndicatorView:(BOOL)isShow
{
    if (isShow)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        UIActivityIndicatorView *ac = [[UIActivityIndicatorView alloc]
                                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        ac.center = headerView.center;
        ac.hidden = YES;
        ac.tag = kActivityIndicatorViewTag;
        [headerView addSubview:ac];
        self.tableView.tableFooterView = headerView;
        
        [ac startAnimating];
    }
    else
    {
        UIActivityIndicatorView *ac = (UIActivityIndicatorView*)[self.tableView.tableHeaderView
                                                                 viewWithTag:kActivityIndicatorViewTag];
        ac.hidden = YES;
        [ac stopAnimating];
        [ac removeFromSuperview];
        
        self.tableView.tableFooterView = nil;
    }
}


// 判断是否有需要继续读取的数据
- (BOOL)isContinueLoad
{
    if (self.isContinued) {
        if ([self.commentsArray count]%PAGE_ENTRYS==0) {
            return YES;
        }
        else{
            self.isContinued = NO;
        }
    }
    return self.isContinued;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.commentsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CommentTableViewCell height:[self.commentsArray objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    cell.commentDict = [self.commentsArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - cell delegate
- (void)viewOriginalAtIndex:(NSInteger)index OfComments:(NSDictionary *)dict
{
    NSArray *thumbnails = [dict objectForKey:@"smallCommentpicList"];
    NSArray *originals = [dict objectForKey:@"commentpicList"];
    
    [self.photos removeAllObjects];
    [self.thumbs removeAllObjects];
    
    for (int i = 0; i < [originals count]; i++) {
        NSString *url = [originals objectAtIndex:i];
        [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:url]]];
        
        if (i<[thumbnails count]) {
            NSString *thumbUrl = [thumbnails objectAtIndex:i];
            [self.thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:thumbUrl]]];
        }
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:index];
    
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - browser delegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

//- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
//    return [[_selections objectAtIndex:index] boolValue];
//}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
//    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
//    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
//}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
