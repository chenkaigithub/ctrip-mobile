//
//  Const.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-18.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_URL @"http://ctrip.herokuapp.com/api/group_product_list/"
#define DAY_INTERVAL 60*60*24

#define ONE_MONTH @"一个月内"
#define THREE_MONTH @"三个月内"
#define HALF_A_YEAR @"六个月内"
#define ONE_YEAR @"一年内"

@interface Const : NSObject

+(id) sharedObject;
-(NSArray *) arrayForTimeRange;
-(NSDictionary *) dictionaryForSortType;

@end
