//
//  RococoAppDelegate.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-11.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MWindow.h"
#import "MNetWork.h"

@class MItemListController;

@interface RococoAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,jsonDelegate>


@property (strong, nonatomic) MWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MItemListController *viewController;
@property (strong, nonatomic) MNetWork *network;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;
@end
