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
#import "AFJSONRequestOperation.h"
#import "NSString+URLEncoding.h"
#import "Item.h"
#import "Const.h"
#import "MNetWork.h"

static NSString *requireURL = @"http://ctrip.herokuapp.com/api/group_product_list/";
#define kAlreadyBeenLaunched @"AlreadyBeenLaunched"

@implementation RococoAppDelegate

#pragma mark - net work delegate

-(void) setJson:(id)json
{
    if ([json isKindOfClass:[NSArray class]]) {
        NSArray *dataList = [NSArray arrayWithArray:json];
        NSMutableArray *itemList = [NSMutableArray arrayWithCapacity:100];
        for (id data in dataList) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                Item *i = [[Item new] autorelease];
                i.name = [data valueForKey:@"name"];
                i.price = [data valueForKey:@"price"];
                i.thumbnailURL = [data valueForKey:@"img"];
                i.productID = [[data valueForKey:@"product_id"] integerValue];
                
                [itemList addObject:i];
                
            }
        }
        
        self.viewController.items = itemList;
        
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
        
        [self.network getJsonDataWithURL:[NSString stringWithFormat:@"%@?city=%@",requireURL,[cityName URLEncode]]];
        
        [self setDefaultValues:cityName];
        
    }];
}

-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
    NSLog(@"error@50,%@",error);
    
    NSString *city = @"北京";
    [self.network getJsonDataWithURL:[NSString stringWithFormat:@"%@?city=%@",requireURL,[city URLEncode]]];
    
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
    [defaults setValue:@"100" forKey:@"top_count"];
    [defaults setValue:@"0" forKey:@"sort_type"];
    [defaults setValue:[[[Const sharedObject]arrayForTimeRange] objectAtIndex:0] forKey:@"time_range"];
    
    [defaults synchronize];
    
}

- (void)dealloc
{
    [_network release];
    [_window release];
    [_viewController release];
    [_locationManager release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    self.window = [[[MWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[MItemListController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    
    self.network = [[MNetWork alloc] init];
    self.network.delegate = self;
    
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
            topCount =@"100";
        }
        
        if (sortType == nil) {
            sortType =@"";
        }
        
        NSString *url = [NSString stringWithFormat:@"%@?city=%@&low_price=%@&upper_price=%@&top_count=%@&sort_type=%@&key_words=%@",requireURL,[city URLEncode],[lowPrice URLEncode],[upperPrice URLEncode],[topCount URLEncode],[sortType URLEncode],@""];
        
        NSLog(@"144@,%@",[city URLEncode]);
        [self.network getJsonDataWithURL:url];
        
    
    }
    
    MNavigationController *nav = [[[MNavigationController alloc] initWithRootViewController:self.viewController]autorelease];
         
    self.window.rootViewController = nav;
    self.viewController.title = @"团购";
    
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
