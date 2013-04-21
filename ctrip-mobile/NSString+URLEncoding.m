//
//  NSString+URLEncoding.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-16.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)
- (NSString *)URLEncode{
    if ([self length] == 0) {
        NSString *str_empty = @"";
        [str_empty autorelease];
        return str_empty;
    }
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
	return result;
}

- (NSString*)URLDecode
{
    if ([self length] == 0 ) {
        return @"";
    }
    
	NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8);
    [result autorelease];
	return result;
}
@end
