//
//  MItemListController.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-12.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MItemListController.h"
#import "MItemCell.h"
#import "UIImageView+AFNetworking.h"
#import "Item.h"
#import "MConfigController.h"
#import "MItemDetailController.h"
#import "Const.h"
#import "ItemDetail.h"
#import <MapKit/MapKit.h>
#import "UIActionSheet+Blocks.h"
#import "MMyOrderController.h"
@interface MItemListController ()
    
@end

@implementation MItemListController
@synthesize items;
@synthesize title;

#pragma mark -
#pragma mark UIView
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)showConfig{
    MConfigController *controller = [[[MConfigController alloc] initWithStyle:UITableViewStyleGrouped]autorelease];
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showOrders
{
    MMyOrderController *controller = [[[MMyOrderController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    controller.title = @"购买纪录";
    [self.navigationController pushViewController:controller animated:YES];

}

-(void)showActionSheet
{
    RIButtonItem *configItem = [RIButtonItem item];
    configItem.label = @"选项";
    configItem.action = ^{
        [self showConfig];
    };
    
    RIButtonItem *myorderItem = [RIButtonItem item];
    myorderItem.label = @"购买纪录";
    myorderItem.action = ^{
        [self showOrders];
    };
    
    RIButtonItem *cancelButton = [RIButtonItem itemWithLabel:@"取消"];
    
    UIActionSheet *actionSheet  = [[[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:cancelButton destructiveButtonItem:nil otherButtonItems:configItem,myorderItem, nil] autorelease ];
    actionSheet.actionSheetStyle =UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.title;
    
    //UIBarButtonItem *settingsButton = [[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleBordered target:self action:@selector(showConfig)] autorelease];
    UIBarButtonItem *actionButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet)] autorelease];
    
    //UIBarButtonItem *settingsButton = [[[UIBarButtonItem alloc] initWithTitle:@"选项" style:UIBarButtonItemStyleBordered target:self action:@selector(showConfig)] autorelease];
    
    self.navigationItem.rightBarButtonItem = actionButton;//settingsButton;//btnConfig;
    
    
    // Remove table cell separator
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
   }



-(void)dealloc
{
    [self.title release];
    [self.items release];
    [super dealloc];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MItemCell";
    MItemCell *cell = (MItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    Item *item = [items objectAtIndex:[indexPath row]];
    
    [cell.thumbnailView setImageWithURL:[NSURL URLWithString:item.thumbnailURL] placeholderImage:[UIImage imageNamed:@"thumbnail.png"]];
    
    cell.nameLabel.text = item.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"价格：¥ %@",item.price];
    cell.descLabel.text = item.desc;
    
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [items objectAtIndex:[indexPath row]];
    NSInteger productID = item.productID;
    
    NSLog(@"@145, product_id=%d",productID);
    
    NSString *url = [NSString stringWithFormat:@"%@%@/?product_id=%d",API_BASE_URL,GROUP_PRODUCT_PARAMTER,productID];
    
    [self.network httpJsonResponse:url byController:self];
}

-(void)setJSON:(id)json fromRequest:(NSURLRequest *)request
{
    MItemDetailController *controller = [[[MItemDetailController alloc] init] autorelease];
    
    ItemDetail *detail = [[[ItemDetail alloc] init] autorelease];
    detail.productID = [[json valueForKey:@"product_id"] integerValue];
    detail.name =[json valueForKey:@"name"];
    
    detail.desc = [json valueForKey:@"description"];
    detail.ruleDesc = [json valueForKey:@"rule_description"];
    detail.headDesc = [json valueForKey:@"head_description"];
    
    detail.tel = [json valueForKey:@"tel"];
    detail.price = [json valueForKey:@"price"];
    detail.address = [json valueForKey:@"address"];
    
    CLLocationCoordinate2D loaction;
    
    loaction.latitude = [[json valueForKey:@"lat"] floatValue];
    loaction.longitude = [[json valueForKey:@"lon"] floatValue];
    
    detail.location = loaction;
    
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:5];
    
    NSArray *list = [json objectForKey:@"pictures"];
    
    for (id object in list) {
        
        NSString * url = [object valueForKey:@"url"];
        
        [images addObject:url];
    }
    
    detail.imageList = images;
    controller.detail = detail;
    
    [self.navigationController pushViewController:controller animated:YES];

}

@end
