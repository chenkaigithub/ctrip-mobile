//
//  MItemListController.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-12.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MItemListController : UITableViewController<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@property (nonatomic,retain) CLLocationManager *locationManager;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;
@end
