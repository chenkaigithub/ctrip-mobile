//
//  MPaymentController.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-25.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MPaymentController.h"

@interface MPaymentController ()

@end

@implementation MPaymentController
@synthesize redirectHtml = _redirectHtml;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIWebView *webView = [[[UIWebView alloc] initWithFrame:self.view.bounds] autorelease];
    
    [webView loadHTMLString: self.redirectHtml baseURL:nil];
    
    [webView setScalesPageToFit:YES];
    
    [self.view addSubview:webView];
    
    self.title = @"支付";
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
