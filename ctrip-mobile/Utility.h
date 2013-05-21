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

-(NSManagedObjectContext *)getManagedObjectContext;

-(void) createOrderEntity:(NSString *)orderID name:(NSString *)name
                   status:(NSString *)status email:(NSString *)email tel:(NSString *)tel price:(NSString *)price
                 quantity:(NSString *)quantity product:(NSString *)productID;

-(NSArray *)getQueryObjectByPredicate:(NSPredicate *)predicate entityForName:(NSString *)entityName;

-(id) queryOrderEntityByOrderID:(NSString *)orderID;

-(void)saveSharedContext;

@end
