//
//  UserDefaults.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-17.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject

@property (nonatomic,retain) NSString *cityName;
@property (nonatomic,retain) NSString *keyWords;
@property (nonatomic,retain) NSString *beginDate;
@property (nonatomic,retain) NSString *endDate;
@property (nonatomic,retain) NSString *lowPrice;
@property (nonatomic,retain) NSString *upperPrice;
@property (nonatomic,retain) NSString *sortType;

@end
