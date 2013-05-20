//
//  RococoAppDelegate.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-11.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//


#import "RococoAppDelegate.h"

#import "MItemListController.h"
#import "MNavigationController.h"
#import "AFNetworking.h"
#import "NSString+Category.h"
#import "Item.h"
#import "Const.h"
#import "MNetWork.h"
#import "Reachability.h"
#import "Utility.h"
#import "NSString+Category.h"
#import "OrderEntity.h"
#import "UIAlertView+Blocks.h"
#import "MOrderDetailController.h"

#define requireURL  [NSString stringWithFormat:@"%@%@/?page_index=%d%@",API_BASE_URL,GROUP_LIST_PARAMTER,1,PAGE_SIZE_PARAMTER]

#define kAlreadyBeenLaunched @"AlreadyBeenLaunched"

@implementation RococoAppDelegate

- (void)saveContext
{
    
    NSError *error = nil;
    NSManagedObjectContext *objectContext = self.managedObjectContext;
    if (objectContext != nil)
    {
        if ([objectContext hasChanges] && ![objectContext save:&error])
        {
            // add error handling here
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
//Explicitly write Core Data accessors
- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MDB" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    //managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"ctrip-mobile.sqlite"]];
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[self managedObjectModel]];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
#pragma mark - net work delegate

-(void) setJSON:(id)json fromRequest:(NSURLRequest *)request
{
    NSString *path = [[request URL] path];
    
    if ([path isEqualToString:GROUP_LIST_PARAMTER]) {
        NSArray *items = [[Const sharedObject] getProudctItemListFromRequest:request withJSON:json];
        NSString *city = [[Const sharedObject] getQueryValueFromRequest:request byKey:@"city"];
        
        NSUInteger count = [[json objectForKey:@"count"] integerValue];
        
        self.viewController.items = items;
        self.viewController.itemTotalCount = count;
        self.viewController.title = city;
        
        [self.viewController.tableView reloadData];
        
    }
    
}


#pragma mark - location manager delegate
    
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self locationManager:manager didUpdateToLocation:[locations objectAtIndex:0] fromLocation:[locations objectAtIndex:0]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    
    CLGeocoder *geoCoder = [[[CLGeocoder alloc] init]autorelease];
    
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        
        NSString *cityName = [placemark.locality stringByReplacingOccurrencesOfString:@"市" withString:@""];
        
        [self.network httpJsonResponse:[NSString stringWithFormat:@"%@&city=%@",requireURL,[cityName URLEncode]] byController:self.viewController];
        
        [self setDefaultValues:cityName];
        
    }];
}

-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
    NSLog(@"error@50,%@",error);
    
    NSString *city = @"北京";
    [self.network httpJsonResponse:[NSString stringWithFormat:@"%@&city=%@",requireURL,[city URLEncode]]byController:self.viewController];
    
    [self setDefaultValues:city];
    
}

-(void) locateDevice{

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

-(void) setDefaultValues:(NSString *)city{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:city forKey:@"city"];
    [defaults setValue:@"0" forKey:@"low_price"];
    [defaults setValue:@"8000" forKey:@"upper_price"];
    [defaults setValue:@"0" forKey:@"top_count"];
    [defaults setValue:@"0" forKey:@"sort_type"];
    [defaults setValue:[[[Const sharedObject]arrayForTimeRange] objectAtIndex:0] forKey:@"time_range"];
    
    [defaults synchronize];
    
}

- (void)dealloc
{
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
    [_nav release];
    [_network release];
    [_window release];
    [_viewController release];
    [_locationManager release];
    [super dealloc];
}

# pragma mark -- reachability method

-(void)setReachability
{
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://www.apple.com"]];
    [client setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSLog(@"%d", status);
        
        if (client.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN ||
            client.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi ) {
            
            NSLog(@"connection");
        }
        else {
            NSLog(@"fail");
            
            [[Utility sharedObject] showNotificationWithMessage:@"你的网络连接断开了" inController:self.viewController];
        }
    }];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024 diskCapacity:40 * 1024 * 1024 diskPath:nil];
    
    [NSURLCache setSharedURLCache:URLCache];
   
    
    self.window = [[[MWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    self.viewController = [[[MItemListController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    
    self.network = [[MNetWork alloc] init];
    self.network.delegate = self;
    
    [self setReachability];
    
    self.nav = [[[MNavigationController alloc] initWithRootViewController:self.viewController]autorelease];
    
    self.window.rootViewController = self.nav;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"AlreadyBeenLaunched"]) {
        // This is our very first launch
        NSLog(@"value==%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"AlreadyBeenLaunched"]);
        
        [self locateDevice];
        // Setting userDefaults for next time
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"AlreadyBeenLaunched"];
    }
    else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *city = [defaults valueForKey:@"city"];
        NSString *lowPrice = [defaults valueForKey:@"low_price"];
        NSString *upperPrice = [defaults valueForKey:@"upper_price"];
        NSString *topCount = [defaults valueForKey:@"top_count"];
        NSString *sortType = [defaults valueForKey:@"sort_type"];
        
        if (city.length == 0) {
            city =@"";
        }
        
        if (lowPrice.length == 0 ) {
            lowPrice =@"0";
        }
        
        if (upperPrice.length ==0) {
            upperPrice = @"800";
        }
        
        if (topCount.length ==0) {
            topCount =@"0";
        }
        
        if (sortType == nil) {
            sortType =@"";
        }
        
        NSString *url = [NSString stringWithFormat:@"%@&city=%@&low_price=%@&upper_price=%@&top_count=%@&sort_type=%@&key_words=%@",requireURL,[city URLEncode],[lowPrice URLEncode],[upperPrice URLEncode],[topCount URLEncode],[sortType URLEncode],@""];
        
        NSLog(@"144@,%@,%@",[city URLEncode],city);
        
        [self.network httpJsonResponse:url byController:self.viewController];
        
    
    }
    
    
    
    [self.window makeKeyAndVisible];
    
    [self startAnimation];
    
    return YES;
}


-(void)startAnimation{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIImageView *splashView = [[UIImageView alloc] initWithFrame:screenRect];
    splashView.image = [UIImage imageNamed:@"Default.png"];
    
    UIImageView *houseView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 256, 256)] autorelease];
    houseView.image = [UIImage imageNamed:@"House-256.png"];
    houseView.center = CGPointMake(screenWidth/2, screenHeight*3/5);
    [splashView addSubview:houseView];
    
    UIImageView *planeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 155, 100)];
    planeView.image = [UIImage imageNamed:@"airplane.png"];
    [self.window addSubview:splashView];
    [self.window bringSubviewToFront:splashView];
    [splashView addSubview:planeView];

    [planeView setCenter:CGPointMake(-155/2.0, screenHeight)];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:3.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    
    
    [planeView setCenter:CGPointMake(screenWidth+155/2, 0)];
    [UIView commitAnimations];
    [planeView release];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:4.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    splashView.alpha = 0.0;
    [UIView commitAnimations];
    
    [splashView release];
}
# pragma mark -ipc method
-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *scheme = [url scheme];
    if ([scheme isEqualToString:@"ctrip"]) {
        
        NSString *query = [url query];
        NSLog(@"@231,%@",query);
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        for (NSString *param in [query componentsSeparatedByString:@"&"]) {
            
            NSArray *kv = [param componentsSeparatedByString:@"="];
            
            if ([kv count]<2) {
            
                [params setObject:@"" forKey:[kv objectAtIndex:0]];
                
                continue;
            }
            
            id value = [kv objectAtIndex:1];
            
            if ([value isKindOfClass:[NSString class]]) {
                NSString *v = (NSString *)[value URLDecode];
                NSLog(@"@253,v==%@",v);
                [params setObject:v forKey:[kv objectAtIndex:0]];
                continue;
            }
            
            [params setObject:[kv objectAtIndex:1] forKey:[kv objectAtIndex:0]];
        }
        
        //NSString *amount = [params valueForKey:@"Amount"];
        //NSString *currencyCode = [params objectForKey:@"CurrencyCode"];
        //NSString *merchantData = [[params valueForKey:@"MerchantData"] URLDecode];
        NSString *orderID = [params objectForKey:@"OrderID"];
        NSInteger status = [[params objectForKey:@"Status"] intValue];
        //NSString *transactionID = [params objectForKey:@"TransactionID"];
        
        if (status==1) {
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"OrderEntity" inManagedObjectContext:[self managedObjectContext]];
            [request setEntity:entity];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(orderID = %@)",orderID];
            
            [request setPredicate:predicate];
            
            NSError *error;
            
            NSArray *objects = [[self managedObjectContext] executeFetchRequest:request error:&error];
            
            if ([objects count]==0) {
                NSLog(@"no matches");
            }
            else{
                OrderEntity *o = [objects objectAtIndex:0];
                o.orderStatus = @"已提交";//[NSString stringWithFormat:@"%d",status];
                NSError *error;
                
                if (![[self managedObjectContext] save:&error]) {
                    NSLog(@"error!");
                }else {
                    NSLog(@"save order ok.");
                }

            }
            [request release];
            
            if ([[[self.nav viewControllers] lastObject] isKindOfClass:[MOrderDetailController class]]) {
                MOrderDetailController *controller = (MOrderDetailController *)[[self.nav viewControllers] lastObject];
                [controller loadDataFromDB];
            }
            
            RIButtonItem *callButton = [RIButtonItem item];
            callButton.label = @"致电客服";
            callButton.action = ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10106666"]];
            };
            
            RIButtonItem *cancelButton = [RIButtonItem item];
            cancelButton.label = @"确定";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"稍后将有短信和邮件提醒，请注意查收。\n如有任何疑问，请拨打1010-6666客服热线。" cancelButtonItem:cancelButton otherButtonItems:callButton, nil];
            [alert show];
            [alert release];
            
            
        }
        
        return YES;
    }
    return NO;
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
