//
//  Const.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-18.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "Const.h"
#import "NSString+Category.h"
#import "Item.h"
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

-(NSString *)getQueryValueFromRequest:(NSURLRequest *)request byKey:(NSString *)key
{
    NSArray *params = [[[request URL] query] componentsSeparatedByString:@"&"];
    
    NSString *result = @"";
    
    for (NSString *str in params) {
        NSArray *kv = [str componentsSeparatedByString:@"="];
        if ([[kv objectAtIndex:0] isEqualToString:key]) {
            result = [[kv objectAtIndex:1] URLDecode];
        }
    }
    
    return result;

}
-(NSArray *)getProudctItemListFromRequest:(NSURLRequest *)request withJSON:(id)json
{
    NSString *path = [[request URL] path];
    NSArray *itemList = [[[NSArray alloc] init]autorelease];
    
    if ([path isEqualToString:GROUP_LIST_PARAMTER]) {
        NSArray *list = (NSArray *)[json objectForKey:@"items"];
        
        for (id data in list) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                
                Item *item = [[[Item alloc] initWithDictionary:data] autorelease];
                
                itemList = [itemList arrayByAddingObject:item];
                
            }
        }
    }
    
    return itemList;
}

@end
