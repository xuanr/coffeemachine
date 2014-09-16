//
//  CoffeeViewController.m
//  coffeeMachine
//
//  Created by Beifei on 5/20/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//

#import "CoffeeViewController.h"
#import "CoffeeMachineTableViewCell.h"
#import "CoffeeMapTableViewCell.h"
#import <MapKit/MapKit.h>
#import "CoffeeAnnotation.h"
#import "SMCalloutView.h"
#import "SVPulsingAnnotationView.h"

typedef enum
{
    ViewType_List,
    ViewType_Map
} ViewType;

@interface CoffeeViewController ()<UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate,SMCalloutViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, assign) MKCoordinateSpan currentSpan;

@property (nonatomic, strong) NSString *lastSearchText;

@property (strong, nonatomic) NSArray *machines;
@property (strong, nonatomic) NSMutableArray* machinesArray;
@property (strong, nonatomic) NSMutableArray *searchResults;

@property (strong, nonatomic) NSArray *mapMachinesArray;
@property (strong, nonatomic) NSMutableDictionary *machinesDict;
@property (strong, nonatomic) NSMutableArray *annotationsArray;

@property (nonatomic, assign) ViewType viewType;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) SMCalloutView *calloutView;
@property (nonatomic, strong) UITableView *calloutTableView;

@end

@implementation CoffeeViewController

static NSString *identifier = @"coffeemachinecell";
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
    self.title = NSLocalizedString(@"Coffee Machine location", nil);
    self.navigationController.navigationBar.translucent = NO;
    
    self.machines = [[NSUserDefaults standardUserDefaults]objectForKey:@"coffeeMachineList"];
    self.machinesArray = [NSMutableArray arrayWithArray:self.machines];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.currentLocation = [[CLLocation alloc]initWithLatitude:30.18 longitude:120.19];
    self.currentSpan = MKCoordinateSpanMake(0.01, 0.01);
    if ([CLLocationManager locationServicesEnabled]&& [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
        [self.locationManager startUpdatingLocation];
    }
    else {
        [self createData];
    }
    
    [self setRegion];
    self.calloutView = [SMCalloutView platformCalloutView];
    self.calloutView.delegate = self;
    self.calloutTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 260, 45)];
    self.calloutTableView.delegate = self;
    self.calloutTableView.dataSource = self;
    self.calloutTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.calloutView.contentView = self.calloutTableView;
    
    self.viewType = ViewType_Map;
    [self locate:nil];
    
    self.annotationsArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createData
{
    [self countDistance];
    [self sortData];
    self.searchResults = [NSMutableArray arrayWithArray:self.machinesArray];
    [self createMapData];
    
    [self.tableview reloadData];
}

- (void)createMapData
{
    self.machinesDict = [NSMutableDictionary dictionary];
    for (NSDictionary *machine in self.searchResults) {
        NSString *key = [NSString stringWithFormat:@"%@,%@",[machine objectForKey:@"longtitude"],[machine objectForKey:@"latitude"]];
        NSMutableArray *array = [self.machinesDict objectForKey:key];
        if (!array) {
            array = [NSMutableArray array];
        }
        [array addObject:machine];
        [self.machinesDict setObject:array forKey:key];
    }
}

- (void)countDistance
{
    [self.machinesArray removeAllObjects];
    for (NSDictionary *machine in self.machines) {
        
        NSMutableDictionary *m = [NSMutableDictionary dictionaryWithDictionary:machine];
        
        CLLocation *location = [[CLLocation alloc]initWithLatitude:[[machine objectForKey:@"latitude"]doubleValue] longitude:[[machine objectForKey:@"longtitude"]doubleValue]];
        double distance = [self.currentLocation distanceFromLocation:location];
        [m setObject:[NSNumber numberWithDouble:distance] forKey:@"distance"];
        
        [self.machinesArray addObject:m];
    }
}

- (void)sortData
{
    [self.machinesArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSMutableDictionary *machine1 = (NSMutableDictionary *)obj1;
        NSMutableDictionary *machine2 = (NSMutableDictionary *)obj2;
        
        double distance1 = [[machine1 objectForKey:@"distance"]doubleValue];
        double distance2 = [[machine2 objectForKey:@"distance"]doubleValue];
        
        if (distance1 < distance2) {
            return NSOrderedAscending;
        }
        else if (distance1 > distance1) {
            return NSOrderedSame;
        }
        else {
            return NSOrderedDescending;
        }
    }];
}

-(void)setRegion
{
    MKCoordinateRegion userLocation = MKCoordinateRegionMake(self.currentLocation.coordinate, self.currentSpan);
    
    [self.mapView setRegion:userLocation animated:YES];
}

#pragma mark - map view delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.currentLocation = userLocation.location;
    [self setRegion];
    
    [self createData];
}

#pragma mark - locationManager
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    self.currentLocation = newLocation;
    [self.locationManager stopUpdatingLocation];
    
    [self setRegion];
    [self createData];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self createData];
}

- (IBAction)locate:(id)sender
{
    if (self.viewType == ViewType_List) {
        
        self.tableview.hidden = YES;

        self.mapView.hidden = NO;
        [UIView beginAnimations:@"animation" context:nil];
        [UIView setAnimationDuration:1.0f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        [UIView commitAnimations];
      
        UIButton *btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"btn_list"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(locate:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(0, 0, 25, 25)];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = item;
        self.viewType = ViewType_Map;
        
        [self addPin];
    }
    else
    {
        self.tableview.hidden = NO;
        self.mapView.hidden = YES;
        [UIView beginAnimations:@"animation" context:nil];
        [UIView setAnimationDuration:1.0f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        [UIView commitAnimations];
        UIButton *btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(locate:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(0, 0, 25, 25)];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = item;
        self.viewType = ViewType_List;
    }
}

- (void)addPin
{
    [self.mapView removeAnnotations:self.annotationsArray];
    [self.annotationsArray removeAllObjects];
    
    NSArray *keys = [self.machinesDict allKeys];
    
    for (NSString *key in keys) {
        
        NSArray *coords = [key componentsSeparatedByString:@","];
        
        double longitude = [[coords objectAtIndex:0]doubleValue];
        double latitude = [[coords objectAtIndex:1]doubleValue];
        
        CoffeeAnnotation *coffee = [[CoffeeAnnotation alloc]initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
        coffee.key = key;
        [self.mapView addAnnotation:coffee];
        [self.annotationsArray addObject:coffee];
    }
}

#pragma mark - mapviewdelegate
-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]])
    {
        static NSString *identifier = @"currentLocation";
		SVPulsingAnnotationView *pulsingView = (SVPulsingAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		
		if(pulsingView == nil) {
			pulsingView = [[SVPulsingAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pulsingView.annotationColor = [UIColor colorWithRed:0.678431 green:0 blue:0 alpha:1];
            pulsingView.canShowCallout = YES;
        }
		
		return pulsingView;
    }
    
    static NSString *CoffeeAnnotationIdentifier = @"CoffeeAnnotationIdentifier";
    
    MKAnnotationView *coffeeAnnotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:CoffeeAnnotationIdentifier];
    
    if (coffeeAnnotationView == nil)
    {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:CoffeeAnnotationIdentifier];
        annotationView.image = [UIImage imageNamed:@"icon_coffeeMachine"];
        return annotationView;
    }
    else {
        coffeeAnnotationView.annotation = annotation;
        return coffeeAnnotationView;
    }
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (![view.annotation isKindOfClass:[CoffeeAnnotation class]]) {
        return;
    }
    CoffeeAnnotation *annotation = view.annotation;
    NSString *key = annotation.key;
    
    self.mapMachinesArray = [self.machinesDict objectForKey:key];
    
    CGRect frame = self.calloutTableView.frame;
    if ([self.mapMachinesArray count]>=3) {
        frame.size.height = 140;
    }
    else {
        frame.size.height = [self.mapMachinesArray count]*45+5;
    }
    [self.calloutTableView setFrame:frame];
    
    
    // iOS 7 only: Apply our view controller's edge insets to the allowable area in which the callout can be displayed.
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        self.calloutView.constrainedInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
    
    // This does all the magic.
    [self.calloutView presentCalloutFromRect:view.bounds inView:view constrainedToView:self.mapView animated:NO];
    [self.calloutTableView reloadData];
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    [self.calloutView dismissCalloutAnimated:NO];
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.calloutTableView == tableView) {
        return 45;
    }
    else {
        return 58;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableview) {
        return [self.searchResults count];
    }
    else {
        return [self.mapMachinesArray count];
    }
}

static CoffeeMachineTableViewCell *lastCell = nil;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableview) {
        
        CoffeeMachineTableViewCell *cell = nil;
        cell = [self.tableview dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[CoffeeMachineTableViewCell alloc]init];
        }
        
        NSDictionary *celldata = [self.searchResults objectAtIndex:indexPath.row];
        cell.data = celldata;
        
        NSNumber *longitude = [celldata objectForKey:@"longtitude"];
        NSNumber *latitude = [celldata objectForKey:@"latitude"];
        
        BOOL setWhite = YES;
        NSInteger row = indexPath.row;
        if (row > 0) {
            NSDictionary *formerData = [self.searchResults objectAtIndex:row - 1];
            
            NSNumber *formerLongitude = [formerData objectForKey:@"longtitude"];
            NSNumber *formerLatitude = [formerData objectForKey:@"latitude"];
            
            if ([formerLongitude isEqualToNumber:longitude] && [formerLatitude isEqualToNumber:latitude]) {
                
                if (!lastCell.isWhite) {
                    setWhite = NO;
                }
            }
            else {
                if (lastCell.isWhite) {
                    setWhite = NO;
                }
            }
        }
        
        BOOL isLast = YES;
        if ([self.searchResults count]-1>indexPath.row) {
            
            NSDictionary *laterData = [self.searchResults objectAtIndex:indexPath.row + 1];
            
            NSNumber *laterLongitude = [laterData objectForKey:@"longtitude"];
            NSNumber *laterLatitude = [laterData objectForKey:@"latitude"];
            
            if ([laterLongitude isEqualToNumber:longitude]&&[laterLatitude isEqualToNumber:laterLatitude]) {
                isLast = NO;
            }
        }
        
        [cell setWhiteCell:setWhite last:isLast];
        
        if (indexPath.row == [self.searchResults count]) {
            lastCell = nil;
        }
        else {
            lastCell = cell;
        }
        
        return cell;
    }
    else {
        CoffeeMapTableViewCell *cell = [CoffeeMapTableViewCell getInstanceWithNibWithBlock];
        NSDictionary *celldata = [self.mapMachinesArray objectAtIndex:indexPath.row];
        cell.data = celldata;
        return cell;
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    self.searchResults = [NSMutableArray arrayWithArray:self.machinesArray];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.lastSearchText = @"";
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self startSearch:searchBar.text];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)search:(NSString *)searchString inArray:(NSArray *)array
{
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    
    __weak CoffeeViewController *vc = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        if ([searchString isEqualToString:@""]) {
            vc.searchResults = [NSMutableArray arrayWithArray:self.machinesArray];
        }
        else
        {
            for (NSDictionary *dict in array) {
                NSDictionary *machine = [dict objectForKey:@"info"];
                NSString *address = [machine objectForKey:@"address"];
                
                if ([address rangeOfString:searchString].length>0) {
                    [vc.searchResults addObject:dict];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.viewType == ViewType_List) {
                [vc.tableview reloadData];
            }
            else {
                [self createMapData];
                [self addPin];
            }
        });
    });
}

- (void)startSearch:(NSString *)searchString
{
    if ([searchString rangeOfString:self.lastSearchText].length > 0) {
        NSArray *array = [NSArray arrayWithArray:self.searchResults];
        [self search:searchString inArray:array];
    }
    else {
        [self search:searchString inArray:[NSArray arrayWithArray:self.machinesArray]];
    }
    
    self.lastSearchText = searchString;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - mapview delegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.currentSpan = self.mapView.region.span;
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
