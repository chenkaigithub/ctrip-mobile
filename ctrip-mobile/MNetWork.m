//
//  MNetWork.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-19.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MNetWork.h"
#import "AFJSONRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"
@implementation MNetWork

@synthesize delegate;
-(void)getJsonDataWithURL:(NSString *)str
{
    NSLog(@"17@,%@",str);
    NSURL *url = [NSURL URLWithString:str];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [delegate setJson:JSON];
        
 
        
    } failure:^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON){
        NSLog(@"Failed: %@",[error localizedDescription]);
        
        [[AFNetworkActivityIndicatorManager  sharedManager] setEnabled:NO];
    }];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [operation start];
    
}

@end
