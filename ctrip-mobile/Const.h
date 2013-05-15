//
//  Const.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-18.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define API_BASE_URL                    @"http://ctrip.herokuapp.com"

#define GROUP_LIST_PARAMTER             @"/api/group_product_list"
#define GROUP_PRODUCT_PARAMTER          @"/api/group_product_info"
#define GROUP_QUERY_TICKETS_PARAMTER    @"/api/group_query_tickets"
#define GROUP_CREATE_ORDER_PARAMTER     @"/api/create_group_order"
#define GROUP_ORDER_LIST_PARAMTER       @"/api/group_order_list"
#define GROUP_CANCEL_TICKETS_PARAMTER   @"/api/group_cancel_tickets"

#define PAYMENT_PARAMTER                @"/api/get_payment"

#define PROVINCE_LIST_PARAMTER          @"/api/province_list"
#define CITY_LIST_PARAMTER              @"/api/city_list"


#define THUMBNAIL_URL                   @"http://thumbnail.herokuapp.com/app/"
#define PAGE_SIZE_PARAMTER                       @"&page_size=10"

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
