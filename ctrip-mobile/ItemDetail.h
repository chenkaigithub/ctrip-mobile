//
//  ItemDetail.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-22.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ItemDetail : NSObject

@property (assign,nonatomic) NSUInteger productID;
@property (retain,nonatomic) NSString *name;
@property (retain,nonatomic) NSString *desc;
@property (retain,nonatomic) NSString *ruleDesc;
@property (retain,nonatomic) NSString *headDesc;
@property (retain,nonatomic) NSString *price;
@property (retain,nonatomic) NSString *address;
@property (retain,nonatomic) NSString *tel;
@property (assign,nonatomic) CLLocationCoordinate2D location;
@property (retain,nonatomic) NSArray *imageList;
@property (retain,nonatomic) NSArray *imageDictList;
@end
