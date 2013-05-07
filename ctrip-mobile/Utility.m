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
//#import "NotiView.h"
//#import "NSTimer+Blocks.h"
@implementation Utility

static Utility *sharedObject = nil;


+(id) sharedObject
{
    if (sharedObject == nil) {
        sharedObject = [[Utility alloc] init];
        
    }
    
    return sharedObject;
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
