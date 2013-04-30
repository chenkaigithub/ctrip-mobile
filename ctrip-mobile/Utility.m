//
//  Utility.m
//  ctrip-mobile
//
//  Created by cao guangyao on 13-4-29.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "Utility.h"
#import "JSNotifier.h"
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
