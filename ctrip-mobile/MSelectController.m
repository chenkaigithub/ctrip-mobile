//
//  MSelectController.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-18.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MSelectController.h"
#import "Const.h"
#import "MConfigController.h"
#import "AFJSONRequestOperation.h"
#import "NSString+Category.h"
@interface MSelectController ()

@end

@implementation MSelectController{
    NSInteger checkedIndex;
    NSString *checkedTimeRange;
    NSString *checkedCity;
}

@synthesize tag;
@synthesize dataList;

-(void)setJSON:(id)json fromRequest:(NSURLRequest *)request
{
    MSelectController *controller = [[[MSelectController alloc] initWithStyle:UITableViewStyleGrouped]autorelease];
    
    
    NSMutableArray *city_list = [NSMutableArray arrayWithCapacity:35];
    if ([json isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in (NSArray *)json) {
            NSString *city = [dic valueForKey:@"name"];
            [city_list addObject:city];
        }
        
        
    }
    controller.dataList = city_list;
    controller.title = @"城市";
    controller.tag = 101;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        checkedIndex = [[defaults valueForKey:@"sort_type"] integerValue];
        checkedTimeRange = [defaults valueForKey:@"time_range"];
        checkedCity = [defaults valueForKey:@"city"];
        
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d%d",[indexPath section],[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.text = [self.dataList objectAtIndex:[indexPath row]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (self.tag ==201) {
                        
            NSString *checkedValue = [[[Const sharedObject] dictionaryForSortType] valueForKey:[NSString stringWithFormat:@"%d",checkedIndex]];
            if ([checkedValue isEqualToString:cell.textLabel.text]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
                
            }
        }
        else if (self.tag == 200)
        {
            if ([cell.textLabel.text isEqualToString:checkedTimeRange]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        else if (self.tag == 100)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (self.tag == 101)
        {
            if ([checkedCity isEqualToString:cell.textLabel.text]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
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
#pragma mark - mnetwork delegate
-(void) requestFinishedWithData:(id)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        self.dataList = data;
        [self.tableView reloadData];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (self.tag ==201) {
        NSString *checkedText = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        
        NSArray *keys = [[[Const sharedObject] dictionaryForSortType] allKeysForObject:checkedText];
        NSString *key = [keys objectAtIndex:0];
        
        [defaults setValue:key forKey:@"sort_type"];
        [defaults synchronize];
        checkedIndex = [key integerValue];
        
        [tableView reloadData];
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    else if (self.tag == 200)
    {
        NSString *checkedText = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [defaults setValue:checkedText forKey:@"time_range"];
        [defaults synchronize];
        
        [tableView reloadData];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.tag ==100)
    {
        NSString *city_encode = [[tableView cellForRowAtIndexPath:indexPath].textLabel.text URLEncode];
        
        [self.network httpJsonResponse:[NSString stringWithFormat:@"%@%@/?province_name=%@",API_BASE_URL,CITY_LIST_PARAMTER,city_encode] byController:self];
    }
    else if (self.tag == 101)
    {
        NSString *checkedText = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [defaults setValue:checkedText forKey:@"city"];
        [defaults synchronize];
        [tableView reloadData];
        UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:1];
        [self.navigationController popToViewController:controller animated:YES];
    }
    
    
    
        
    
    
}

-(void) requireDataWithURL:(NSString *) urlString ToController:(MSelectController *)controller {
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSMutableArray *city_list = [NSMutableArray arrayWithCapacity:35];
        if ([JSON isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in (NSArray *)JSON) {
                NSString *city = [dic valueForKey:@"name"];
                [city_list addObject:city];
            }
            controller.dataList = city_list;
            [controller.tableView reloadData];
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON){
        NSLog(@"Failed: %@",[error localizedDescription]);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation start];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

@end
