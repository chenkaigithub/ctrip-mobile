//
//  Const.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-18.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "Const.h"

@implementation Const

static Const *sharedObject = nil;

+(id) sharedObject
{
    if (sharedObject == nil) {
        sharedObject = [[Const alloc] init];
        
    }
    return sharedObject;
}

-(NSArray *) arrayForTimeRange
{
    return @[@"一个月内",@"三个月内",@"六个月内",@"一年内"];
}

-(NSDictionary *)dictionaryForSortType
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"默认",@"0",
                          @"折扣从高到低",@"1",
                          @"折扣从低到高",@"2",
                          @"价格从高到低",@"3",
                          @"价格从低到高",@"4",
                          @"销量从高到低",@"5",
                          @"销量从低到高",@"6",
                          @"星级从高到低",@"7",
                          @"星级从低到高",@"8",
                          @"即将开团",@"9",
                          @"即将到期",@"10", nil];
    return dict;
}

@end
