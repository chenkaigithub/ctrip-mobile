//
//  Const.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-18.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Const : NSObject

+(id) sharedObject;
-(NSArray *) arrayForTimeRange;
-(NSDictionary *) dictionaryForSortType;

@end
