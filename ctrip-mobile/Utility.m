//
//  Utility.m
//  ctrip-mobile
//
//  Created by cao guangyao on 13-4-29.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "Utility.h"
#import "JSNotifier.h"
#import "NSString+Category.h"
#import "RococoAppDelegate.h"
#import "OrderEntity.h"
@implementation Utility

static Utility *sharedObject = nil;


+(id) sharedObject
{
    if (sharedObject == nil) {
        sharedObject = [[Utility alloc] init];
        
    }
    
    return sharedObject;
}
-(NSManagedObjectContext *)getManagedObjectContext
{
    return [(RococoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];

}

-(void)saveContext:(NSManagedObjectContext *)context
{
    NSError *error;
    
    if (![context save:&error]) {
        NSLog(@"error!");
    }else {
        NSLog(@"save order ok.");
    }

}

-(void) createOrderEntity:(NSString *)orderID name:(NSString *)name
status:(NSString *)status email:(NSString *)email tel:(NSString *)tel price:(NSString *)price
quantity:(NSString *)quantity product:(NSString *)productID
{
    NSManagedObjectContext *context = [self getManagedObjectContext];
    
    OrderEntity *o = (OrderEntity *)[NSEntityDescription insertNewObjectForEntityForName:@"OrderEntity" inManagedObjectContext:context];
    o.orderID = orderID;
    o.orderStatus = status;//@"未提交";
    o.orderEmail = email;
    o.orderTel = tel;
    o.orderPrice = price;
    o.orderQuantity = quantity;
    
    
    o.productID = productID;
    o.productName = name;
    
    [self saveContext:context];
    
}

-(id)queryOrderEntityByOrderID:(NSString *)orderID
{
    NSManagedObjectContext *context = [self getManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OrderEntity" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(orderID = %@)",orderID];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    OrderEntity *orderEntity = nil;
    
    if ([objects count]==0) {
        NSLog(@"no matches");
    }
    else{
        orderEntity = [objects objectAtIndex:0];
        
    }
    
    [fetchRequest release];
    
    return orderEntity;
}


-(NSDictionary *)getRequestParams:(NSURLRequest *) request
{
    NSURL *url = [request URL];
    NSString *query = [url query];
    
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init]autorelease];
    
    for (NSString *param in [query componentsSeparatedByString:@"&"]) {
        
        NSArray *kv = [param componentsSeparatedByString:@"="];
        
        if ([kv count]<2) {
            
            [params setObject:@"" forKey:[kv objectAtIndex:0]];
            
            continue;
        }
        
        id value = [kv objectAtIndex:1];
        
        if ([value isKindOfClass:[NSString class]]) {
            NSString *v = (NSString *)[value URLDecode];
            [params setObject:v forKey:[kv objectAtIndex:0]];
            continue;
        }
        
        [params setObject:[kv objectAtIndex:1] forKey:[kv objectAtIndex:0]];
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:params];
    
    return dic;
    
}

-(void) setAlertView:(NSString *)title withMessage:(NSString *)message
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
    
    [alert show];    
}

-(void)showNotificationWithMessage:(NSString *)message inController:(UIViewController *)controller
{
    JSNotifier *notify = [[JSNotifier alloc]initWithTitle:message];
    notify.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NotifyX.png"]];
    [notify showFor:2.0];

}

@end
