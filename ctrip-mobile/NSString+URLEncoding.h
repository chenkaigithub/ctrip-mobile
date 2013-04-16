//
//  NSString+URLEncoding.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-16.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)

- (NSString *)URLEncode;
- (NSString *)URLDecode;

@end
