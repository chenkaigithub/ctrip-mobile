//
//  RococoAppDelegate.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-11.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "RococoAppDelegate.h"

#import "RococoViewController.h"

@implementation RococoAppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[RococoViewController alloc] initWithNibName:@"RococoViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
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
