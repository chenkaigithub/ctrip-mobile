//
//  NSString+Category.h
//  ctrip-mobile
//
//  Created by cao guangyao on 13-4-29.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)

- (NSString *)gtm_stringByEscapingForHTML;
- (NSString *)gtm_stringByEscapingForAsciiHTML;
- (NSString *)gtm_stringByUnescapingFromHTML;

- (NSString *)URLEncode;
- (NSString *)URLDecode;
- (NSString *)stringByConvertingHTMLToPlainText;


+ (BOOL) NSStringIsValidEmail:(NSString *)checkString;
@end
