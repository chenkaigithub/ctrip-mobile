//
//  Utility.h
//  ctrip-mobile
//
//  Created by cao guangyao on 13-4-29.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(id) sharedObject;
-(NSDictionary *)getRequestParams:(NSURLRequest *) request;

-(void) setAlertView:(NSString *)title withMessage:(NSString *)message;

-(void)showNotificationWithMessage:(NSString *)message inController:(UIViewController *)controller;

@end
