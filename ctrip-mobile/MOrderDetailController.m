//
//  MOrderDetailController.m
//  ctrip-mobile
//
//  Created by cao guangyao on 13-5-5.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MOrderDetailController.h"

@interface MOrderDetailController ()

@end

@implementation MOrderDetailController
@synthesize order = _order;
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
    
    self.title = self.order.productName;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [self.order release];
    [super dealloc];
    
}

#pragma mark --table view delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    else
    {
        return 11;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
        NSUInteger section = [indexPath section];
        NSUInteger row = [indexPath row];
        
        if (section == 0 && row == 0) {
            cell.textLabel.text = self.order.productName;
        }
        
        if (section == 1) {
            switch (row) {
                case 0:
                    cell.textLabel.text = @"订单状态";
                    cell.detailTextLabel.text = self.order.orderStatus;
                case 1:
                    cell.textLabel.text =@"单价";
                    cell.detailTextLabel.text = self.order.orderPrice;
                    break;
                case 2:
                    cell.textLabel.text = @"Email";
                    cell.detailTextLabel.text = self.order.orderEmail;
                    break;
                case 3:
                    cell.textLabel.text = @"手机";
                    cell.detailTextLabel.text = self.order.orderTel;
                    break;
                case 4:
                    cell.textLabel.text = @"数量";
                    cell.detailTextLabel.text  = self.order.orderQuantity;
                    break;
                case 5:
                    cell.textLabel.text = @"订单券号码";
                    cell.detailTextLabel.text = self.order.ticketID;
                    break;
                case 6:
                    cell.textLabel.text = @"订单券密码";
                    cell.detailTextLabel.text = self.order.ticketPassword;
                default:
                    break;
            }
        }
    }
    // Configure the cell...
    
    return cell;
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
