//
//  MConfigController.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-17.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MConfigController.h"
#import "MCell.h"
#import "MTextFieldCell.h"

@interface MConfigController ()

@end

@implementation MConfigController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else{
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == 0 ||(section ==1 && row == 2)||(section ==1 && row==3)) {
        NSString *cellIndentifier = @"MTextFieldCell";
        MTextFieldCell *cell = (MTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MTextFieldCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if (section==0 && row ==0) {
            cell.titleLabel.text = @"关键字";
        }
        
        if (section == 1) {
            if (row == 2) {
                cell.titleLabel.text = @"最低价格";
            }
        else if(row == 3){
                cell.titleLabel.text = @"最高价格";
            }
        }
        
        return cell;
    }
    else{
        NSString *cellIndentifier = @"MCell";
        
        MCell *cell = (MCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if (cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MTextFieldCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if (row ==0)
        {
            cell.textLabel.text = @"城市";
        }
        else if(row == 1)
        {
            cell.textLabel.text = @"时间范围";
        }
        else if (row == 4)
        {
            cell.textLabel.text = @"排序";
        }
        
        return cell;
    }
    
    return nil;
    
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
