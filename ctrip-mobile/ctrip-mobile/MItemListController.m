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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.title;
    
    UIBarButtonItem *btnConfig = [[[UIBarButtonItem alloc] initWithTitle:@"选项" style:UIBarButtonItemStyleBordered target:self action:@selector(showConfig)] autorelease];
    
    self.navigationItem.rightBarButtonItem = btnConfig;
    
    
    /*UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];*/
    
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
    
    [cell.thumbnailView setImageWithURL:[NSURL URLWithString:item.thumbnailURL]];
    cell.nameLabel.text = item.name;
    cell.priceLabel.text = item.price;
    
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
    
    NSLog(@"144@%d",productID);
    
    MItemDetailController *controller = [[[MItemDetailController alloc] init]autorelease];
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

@end
