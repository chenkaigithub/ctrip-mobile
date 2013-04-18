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
#import "UserDefaults.h"
#import "Const.h"
#import "MSelectController.h"
#import "AFJSONRequestOperation.h"
@interface MConfigController ()

@end

@implementation MConfigController{
    UserDefaults *userDefaults;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self initData];
    }
    return self;
}

-(void) initData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    userDefaults = [UserDefaults new];
    
    userDefaults.keyWords = [defaults valueForKey:@"key_words"];
    userDefaults.cityName = [defaults valueForKey:@"city"];
    userDefaults.beginDate = [defaults valueForKey:@"begin_date"];
    userDefaults.endDate = [defaults valueForKey:@"end_date"];
    userDefaults.lowPrice = [defaults valueForKey:@"low_price"];
    userDefaults.upperPrice = [defaults valueForKey:@"upper_price"];
    userDefaults.sortType = [defaults valueForKey:@"sort_type"];
    userDefaults.timeRange = [defaults valueForKey:@"time_range"];
}

-(void) doSearch{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)resetData{
    [self initData];
    [self.tableView reloadData];
}

-(void)dealloc
{
    [userDefaults release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选项";
    
    UIBarButtonItem *btnDone = [[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(doSearch)] autorelease];
    
    self.navigationItem.rightBarButtonItem = btnDone;
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self resetData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == 0) {
        static NSString *cellIndentifier = @"MTextFieldCell";
        
        MTextFieldCell *cell = (MTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MTextFieldCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if (row ==0) {
            cell.titleLabel.text = @"关键字";
            
            if (userDefaults.keyWords!=nil) {
                cell.textField.text = userDefaults.keyWords;
            }
        }
        else if (row ==1)
        {
            cell.titleLabel.text = @"最低价格";
            NSLog(@"137,%@",userDefaults.lowPrice);
            if (userDefaults.lowPrice!=nil) {
                cell.textField.text = userDefaults.lowPrice;
            }

        
        }
        else if (row ==2){
            cell.titleLabel.text = @"最高价格";
            
            if (userDefaults.upperPrice != nil) {
                cell.textField.text = userDefaults.upperPrice;
            }
        };
        
        /*if (section == 1) {
            if (row == 2) {
                cell.titleLabel.text = @"最低价格";
                NSLog(@"137,%@",userDefaults.lowPrice);
                if (userDefaults.lowPrice!=nil) {
                    cell.textField.text = userDefaults.lowPrice;
                }
                
            }
            else if(row == 3){
                cell.titleLabel.text = @"最高价格";
            
                if (userDefaults.upperPrice != nil) {
                    cell.textField.text = userDefaults.upperPrice;
                }
            }
        }*/
        
        return cell;
    }
    else{
        static NSString *cellIndentifier1 = @"MCell";
        
        MCell *cell = (MCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentifier1];
        
        if (cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if (row ==0)
        {
            cell.textLabel.text = @"城市";
            
            if (userDefaults.cityName!= nil) {
                cell.detailTextLabel.text =userDefaults.cityName;
            }
            
        }
        else if(row == 1)
        {
            cell.textLabel.text = @"范围";
            
            if (userDefaults.endDate!=nil) {
                cell.detailTextLabel.text = [[[Const sharedObject] arrayForTimeRange] objectAtIndex:0];
            }
            else{
                NSLog(@"156@%@",userDefaults.timeRange);
                cell.detailTextLabel.text = userDefaults.timeRange;
            }
            
        }
        else if (row == 2)
        {
            cell.textLabel.text = @"排序";
            if (userDefaults.sortType!=nil) {
                NSString *key = userDefaults.sortType;
                
                cell.detailTextLabel.text = [[[Const sharedObject]dictionaryForSortType] valueForKey:key];
            }
            else{
                NSString *value =[[[Const sharedObject] dictionaryForSortType] valueForKey:@"0"];
                 cell.detailTextLabel.text = value;
            }
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
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == 1) {
        MSelectController *controller = [[[MSelectController alloc] initWithStyle:UITableViewStyleGrouped]autorelease];
        if (row ==0) {
            //cities
            controller.tag=100;
            controller.title = @"省市自治区";
            [self requireDataWithURL:@"http://ctrip.herokuapp.com/api/province_list/" ToController:controller];
            
            
        }
        else if(row == 1){
            //time range
            controller.tag=200;
            controller.title = @"范围";
            controller.dataList = [NSArray arrayWithArray:[[Const sharedObject] arrayForTimeRange]];
            
        }
        else if(row == 2)
        {
            //sort type
            controller.tag = 201;
            controller.title = @"排序";
            controller.dataList = [[[Const sharedObject] dictionaryForSortType] allValues];
            
        }
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    
 }

-(void) requireDataWithURL:(NSString *) urlString ToController:(MSelectController *) controller{
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSMutableArray *province_list = [NSMutableArray arrayWithCapacity:35];
        if ([JSON isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in (NSArray *)JSON) {
                NSString *province = [dic valueForKey:@"name"];
                [province_list addObject:province];
            }
            NSLog(@"list@296,%@",province_list);
            controller.dataList = province_list;
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
