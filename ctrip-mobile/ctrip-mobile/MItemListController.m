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
#import "NSString+Category.h"
@interface MItemListController ()
{
    NSUInteger pageIndex;
}
    
@end

@implementation MItemListController
@synthesize items=_items;
@synthesize keyWords = _keyWords;


#pragma mark -
#pragma mark UIView
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        pageIndex = 1;
        self.keyWords = @"";
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
    
    UIBarButtonItem *actionButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet)] autorelease];
    
    
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
    if ([self.items count]==0) {
        return 0;
    }
    
    return [self.items count]+1;
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount-1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier =[NSString stringWithFormat: @"MItemCell%d%d",[indexPath row],[indexPath section]];
    MItemCell *cell = (MItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    NSUInteger row = [indexPath row];
    
    if (row<[self.items count]) {
        Item *item = [self.items objectAtIndex:[indexPath row]];
        
        NSString *strThumbnailURL = [NSString stringWithFormat:@"%@%d/?url=%@",THUMBNAIL_URL,58,[item.thumbnailURL URLEncode]];
        
        [cell.thumbnailView setImageWithURL:[NSURL URLWithString:strThumbnailURL] placeholderImage:[UIImage imageNamed:@"thumbnail.png"]];
        
        cell.nameLabel.text = item.name;
        cell.priceLabel.text = [NSString stringWithFormat:@"价格：¥ %@",item.price];
        cell.descLabel.text = item.desc;
        
        
    }
    else
    {
        //clear texts
        cell.thumbnailView = nil;
        cell.nameLabel.text =nil;
        cell.priceLabel.text = nil;
        cell.descLabel.text = nil;
        
        UILabel *moreLabel = [[[UILabel alloc] init] autorelease];
        
        moreLabel.text = @"载入更多...";
        
        [moreLabel sizeToFit];
        [moreLabel setCenter:cell.center];
        [cell addSubview:moreLabel];
    }
    
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
    NSUInteger row = [indexPath row];
    NSUInteger rowCount = [tableView numberOfRowsInSection:[indexPath section]];
    
    if (row<rowCount-1) {
        Item *item = [self.items objectAtIndex:[indexPath row]];
        NSInteger productID = item.productID;
        
        NSLog(@"@145, product_id=%d",productID);
        
        NSString *url = [NSString stringWithFormat:@"%@%@/?product_id=%d",API_BASE_URL,GROUP_PRODUCT_PARAMTER,productID];
        
        [self.network httpJsonResponse:url byController:self];
    }
    else{
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *city = [defaults valueForKey:@"city"];
        NSString *lowPrice = [defaults valueForKey:@"low_price"];
        NSString *upperPrice = [defaults valueForKey:@"upper_price"];
        NSString *topCount = [defaults valueForKey:@"top_count"];
        NSString *sortType = [defaults valueForKey:@"sort_type"];
        
        if (city.length == 0) {
            city =@"";
        }
        
        if (lowPrice.length == 0 ) {
            lowPrice =@"0";
        }
        
        if (upperPrice.length ==0) {
            upperPrice = @"800";
        }
        
        if (topCount.length ==0) {
            topCount =@"0";
        }
        
        if (sortType == nil) {
            sortType =@"";
        }
        
        pageIndex +=pageIndex;
        
        NSString *strURL=[NSString stringWithFormat:@"%@%@/?page_index=%d%@&city=%@&low_price=%@&upper_price=%@&top_count=%@&sort_type=%@&key_words=%@",
                          API_BASE_URL,GROUP_LIST_PARAMTER,pageIndex ,PAGE_SIZE_PARAMTER,
                          [city URLEncode],[lowPrice URLEncode],[upperPrice URLEncode],[topCount URLEncode],[sortType URLEncode],self.keyWords];
        [self.network httpJsonResponse:strURL byController:self];
        
    }
    
    
}

-(void)setJSON:(id)json fromRequest:(NSURLRequest *)request
{
    NSString *path = [[request URL] path];
    
    if ([path isEqualToString:GROUP_LIST_PARAMTER]) {
        NSLog(@"load more...");
        if ([json isKindOfClass:[NSArray class]]) {
            NSArray *dataList = [NSArray arrayWithArray:json];
            for (id data in dataList) {
                if ([data isKindOfClass:[NSDictionary class]]) {
                    Item *i = [[Item new] autorelease];
                    i.name = [data valueForKey:@"name"];
                    i.price = [data valueForKey:@"price"];
                    i.thumbnailURL = [data valueForKey:@"img"];
                    i.productID = [[data valueForKey:@"product_id"] integerValue];
                    i.desc = [[data valueForKey:@"description"] stringByConvertingHTMLToPlainText];
                    
                    
                    [self.items addObject:i];
                    
                    NSUInteger section = 0;
                    NSUInteger row = [self.items count]-1;
                    
                    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationRight];
                }
            }
            
        }
        
    }
    else if([path isEqualToString:GROUP_PRODUCT_PARAMTER])
    {
        MItemDetailController *controller = [[[MItemDetailController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        
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
    

}

@end
