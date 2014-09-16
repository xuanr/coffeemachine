//
//  AppDelegate.m
//  coffeeMachine
//
//  Created by Beifei on 5/16/14.
//  Copyright (c) 2014 iChuansuo. All rights reserved.
//test moudle

#import "AppDelegate.h"
#import "XHDrawerController.h"
#import "SlideNavigationViewController.h"
#import "MainViewController.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "PartnerConfig.h"
#import "PayResultViewController.h"
#import "CartTableViewController.h"
#import "AccountViewController.h"
#import "CoffeePictureUpdateManager.h"
#import "GuideViewController.h"

@interface AppDelegate()

@property (nonatomic, strong) NSOperation *checkOperation;
@property (nonatomic, strong) NSOperation *coffeeMachineListOperation;
@property (nonatomic, strong) NSString *downloadUrl;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    if (IOS7) {
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    if (IOS7) {
        [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"navBar_ios7"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    }
    else {
        [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance]setTintColor:BrownColor];
    }
    
    [[UINavigationBar appearance]setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor]}];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    NSNumber *first = [[NSUserDefaults standardUserDefaults]objectForKey:@"firstTime"];
    
    if (!first) {
        GuideViewController *vc = [[GuideViewController alloc]init];
        self.window.rootViewController = vc;
        
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:NO] forKey:@"firstTime"];
    }
    else {
        [self changeRoot];
    }
    
    [self.window makeKeyAndVisible];
    
    //[self registerAPN];
    
    return YES;
}

- (void)changeRoot
{
     XHDrawerController *drawerController = [[XHDrawerController alloc] init];
     drawerController.springAnimationOn = YES;
     
     SlideNavigationViewController *left = [[SlideNavigationViewController alloc]init];
     drawerController.leftViewController = left;
     
     MainViewController *center = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"MainViewController"];
     drawerController.centerViewController = [[UINavigationController alloc]initWithRootViewController:center];
     
     UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_slide"]];
     drawerController.backgroundView = backgroundImageView;
     
     self.window.rootViewController = drawerController;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[CoffeePictureUpdateManager sharedManager]updateCoffeePicList];
    [self updateCoffeeMachine];
    [self versionCheck];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - push
- (void)application:(UIApplication *) application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *) deviceToken {
    NSString *token = [self formattedDeviceToken:deviceToken];
    
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:nil message:token delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [view show];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
}

- (void)registerAPN
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
}

- (NSString *)formattedDeviceToken: (NSData *)token
{
    NSString *deviceToken           = [NSString stringWithFormat:@"%@", token];
    NSCharacterSet *invalidSet      = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdef"] invertedSet];
    NSArray *validArray             = [deviceToken componentsSeparatedByCharactersInSet:invalidSet];
    NSString *formattedDeviceToken  = [validArray componentsJoinedByString:@""];
    return formattedDeviceToken;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	
	[self parse:url application:application];
	return YES;
}

- (void)updateCoffeeMachine
{
    if (self.coffeeMachineListOperation) {
        return;
    }
    
    __weak AppDelegate *obj = self;
    NSString *timeStamp = [[NSUserDefaults standardUserDefaults]objectForKey:@"coffeeMachineTimestamp"];
    if (!timeStamp) {
        timeStamp = @"0";
    }
    
    timeStamp = @"0";
    self.coffeeMachineListOperation = [HttpRequest coffeeMachineListWithTimestamp:timeStamp CompletionWithSuccess:^(NSArray *updateArray,NSString *timeStamp) {
        if ([updateArray count]>0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                
                [[NSUserDefaults standardUserDefaults]setObject:timeStamp forKey:@"coffeeMachineTimestamp"];
                
                NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:@"coffeeMachineList"];
                if (!array) {
                    [[NSUserDefaults standardUserDefaults]setObject:updateArray forKey:@"coffeeMachineList"];
                }
                else {
                    NSMutableArray *oldArray = [NSMutableArray arrayWithArray:array];
                    for (NSDictionary *updateMachineDict in updateArray) {
                        NSDictionary *updateMachineInfo = [updateMachineDict objectForKey:@"info"];
                        BOOL status = [[updateMachineInfo objectForKey:@"status"]boolValue];
                        NSNumber *updateMachineId = [updateMachineInfo objectForKey:@"machineid"];
                        
                        BOOL has = NO;
                        for (NSDictionary *oldMachineDict in oldArray) {
                            NSDictionary *oldMachineInfo = [oldMachineDict objectForKey:@"info"];
                            NSNumber *oldMachineId = [oldMachineInfo objectForKey:@"machineid"];
                            
                            if ([updateMachineId isEqualToNumber:oldMachineId]) {
                                if (status) {
                                    NSInteger index = [oldArray indexOfObject:oldMachineDict];
                                    [oldArray replaceObjectAtIndex:index withObject:updateMachineDict];
                                }
                                else {
                                    [oldArray removeObject:oldMachineDict];
                                }
                                has = YES;
                                break;
                            }
                        }
                        if (!has) {
                            [oldArray addObject:updateMachineDict];
                        }
                    }
                    
                    [[NSUserDefaults standardUserDefaults]setObject:oldArray forKey:@"coffeeMachineList"];
                }
                obj.coffeeMachineListOperation = nil;

            });
        }
    } failure:^(int errorCode) {
        obj.coffeeMachineListOperation = nil;
    }];
}

- (void)versionCheck
{
    if (self.checkOperation) {
        return;
    }
    __weak AppDelegate *obj = self;
    self.checkOperation = [HttpRequest versionCompletionWithSuccess:^(NSString *version, NSString *updateUrl) {
        
        NSDictionary *dict = [[NSBundle mainBundle]infoDictionary];
        NSString *ver = [dict objectForKey:(NSString*)kCFBundleVersionKey];
        self.downloadUrl = updateUrl;
        
        if (![ver isEqualToString:version]) {
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"友情提醒", nil) message:NSLocalizedString(@"赶快去下载最新版～",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"晚点再说", nil) otherButtonTitles:NSLocalizedString(@"现在就去",nil), nil];
            [view show];
        }
        
    } failure:^(int errorCode) {
        obj.checkOperation = nil;
    }];
}

#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.checkOperation = nil;
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.downloadUrl]];
    }
}

- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    
	if (result)
    {
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
            if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                ResultType type;
                if ([[url scheme]isEqualToString:@"coffeeMachineRecharge"]) {
                    type = ResultType_Recharge;
                }
                else {
                    type = ResultType_Pay;
                }
                [self returnFromAlipayWithType:type];
            }
        }
        else
        {
            //交易失败
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"友情提醒", nil) message:result.statusMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [view show];
        }
    }
    else
    {
        //失败
    }
}

- (void)returnFromAlipayWithType:(ResultType)type
{
    
    PayResultViewController *pay = [[PayResultViewController alloc]initWithType:type status:YES];
    
    UIViewController *vc = self.window.rootViewController;
    if ([vc isKindOfClass:[XHDrawerController class]]) {
        
        XHDrawerController *drawerController = (XHDrawerController *)vc;
        UIViewController *c = drawerController.centerViewController;
        
        if ([c isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)c;
            
            NSArray *arr = nav.viewControllers;
            UIViewController *root = [arr objectAtIndex:0];
            if ([root isKindOfClass:[MainViewController class]]) {
                MainViewController *main = (MainViewController *)root;
                [main closeCoffeeView];
                [main dismissViewControllerAnimated:NO completion:nil];
                
                [nav popToRootViewControllerAnimated:NO];
                [nav pushViewController:pay animated:NO];
                return;
            }
        }
        
        MainViewController *center = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"MainViewController"];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:center];
        
        [nav pushViewController:pay animated:NO];
        drawerController.centerViewController = nav;
    }
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
	return [[AlixPayResult alloc] initWithString:query];
#endif
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}

@end
