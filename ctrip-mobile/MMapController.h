//
//  MMapController.h
//  ctrip-mobile
//
//  Created by cao guangyao on 13-4-30.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MMapController : UIViewController<MKMapViewDelegate>

@property (assign,nonatomic)CLLocationCoordinate2D coordinate;
@property (retain,nonatomic)NSString *name;
@property (retain,nonatomic)NSString *address;
@end
