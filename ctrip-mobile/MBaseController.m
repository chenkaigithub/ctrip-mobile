//
//  MBaseController.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-17.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MBaseController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Const.h"

@interface MBaseController ()

@end

@implementation MBaseController

@synthesize network=_network;

-(void)setJSON:(id)json fromRequest:(NSURLRequest *)request 
{
    [[AFNetworkActivityIndicatorManager sharedManager]setEnabled:NO];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.network =[[MNetWork alloc] init];
        self.network.delegate = self;
    }
    return self;
}

-(void) dealloc
{
    [_network release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set back button in navigation bar
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil] autorelease];
    
    self.navigationItem.backBarButtonItem =backButton;
    
    // Assign our own backgroud for the view
    UIImageView *backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_bg.png"]] autorelease];
    self.tableView.backgroundView = backgroundView;
    
    // Add padding to the top of the table view
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
