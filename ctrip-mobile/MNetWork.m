//
//  MNetWork.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-19.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MNetWork.h"
#import "AFNetworking.h"

@implementation MNetWork

@synthesize delegate=_delegate;

#pragma mark -- mbprogresshud delegate

-(void) hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
	[hud release];
	hud = nil;
}

-(void)httpJsonResponse:(NSString *)str byController:(UIViewController *)controller
{
    NSURL *url = [NSURL URLWithString:str];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFNetworkActivityIndicatorManager *indicatorManger = [AFNetworkActivityIndicatorManager sharedManager];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:controller.view];
    
    [controller.view addSubview:hud];
    
    [hud setDelegate:self];
    [hud setLabelText:@"请稍后"];
    
    [hud setDetailsLabelText:@"正在读取数据..."];
    
    [hud setSquare:YES];
    
    [hud show:YES];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [indicatorManger setEnabled:NO];
        
        [hud hide:YES];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [self.delegate setJson:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"Failed:@25,%@",[error localizedDescription]);
        
        [indicatorManger setEnabled:NO];
        
        [hud hide:YES];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
    }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [indicatorManger setEnabled:YES];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [op start];
    
}


-(void)dealloc
{
    [_delegate release];
 
    [super dealloc];
}

@end
