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
    
    
    
    hudView = [[MBProgressHUD alloc] initWithView:self.view];
    
    hudView.delegate = self;
    
    hudView.labelText = @"请稍候,正在努力为亲载入中...";
    
    [hudView showAnimated:YES whileExecutingBlock:^{
		[self waitForDataSource];
	} completionBlock:^{
		[hudView removeFromSuperview];
		[hudView release];
	}];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) waitForDataSource{
    /*
    NSDate *future = [NSDate dateWithTimeIntervalSinceNow:5.00];
    while ([items count]==0) {
        [NSThread sleepUntilDate:future];
    }*/
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
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
    
    /*NSDictionary *itemDict = [self.dataList objectAtIndex:[indexPath row]];
    
    NSString *name = [itemDict valueForKey:@"name"];
    NSString *price = [itemDict valueForKey:@"price"];
    NSString *imageURL = [itemDict valueForKey:@"img"];*/
    
    Item *item = [items objectAtIndex:[indexPath row]];
    
    [cell.thumbnailView setImageWithURL:[NSURL URLWithString:item.thumbnailURL]];
    cell.nameLabel.text = item.name;
    cell.priceLabel.text = item.price;
    
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    
    // Configure the cell...
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
