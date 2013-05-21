//
//  MMyOrderController.m
//  ctrip-mobile
//
//  Created by cao guangyao on 13-5-4.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MMyOrderController.h"
#import "OrderEntity.h"
#import <CoreData/CoreData.h>
#import "RococoAppDelegate.h"
#import "MOrderCell.h"
#import "UIAlertView+Blocks.h"
#import "Utility.h"
#import "MOrderDetailController.h"
#import "NSString+Category.h"
#import "Const.h"
#import "MBProgressHUD.h"
#import "SBJSON.h"
@interface MMyOrderController ()

@property (nonatomic,retain) NSArray *orderEntitys;
@end

@implementation MMyOrderController
@synthesize orderEntitys=_orderEntitys;

#pragma mark -- network delegate


-(void)setJSON:(id)json fromRequest:(NSURLRequest *)request
{
    NSURL *url = [request URL];
    NSString *path = [url path];
    NSDictionary *params =[[Utility sharedObject] getRequestParams:request];
    //get order id from url 
    NSString *orderID = [params valueForKey:@"order_id"];
    
    
    NSLog(@"@38,%@",path);
    
    if ([path isEqualToString:GROUP_ORDER_LIST_PARAMTER]) {
        if ([json isKindOfClass:[NSDictionary class]]) {
            if ([json objectForKey:@"error_msg"]) {
                [[Utility sharedObject] setAlertView:@"" withMessage:[json valueForKey:@"error_msg"]];
                //[fetchRequest release];
                return;
            }
  
            OrderEntity *orderEntity = (OrderEntity *)[[Utility sharedObject] queryOrderEntityByOrderID:orderID];
            
            if (orderEntity!=nil) {
                orderEntity.orderStatus = [json valueForKey:@"status"];
                NSString *strURL = [NSString stringWithFormat:@"%@%@/?order_id=%@",API_BASE_URL,GROUP_QUERY_TICKETS_PARAMTER,orderID];
                
                [self.network httpJsonResponse:strURL byController:self];
            }
            
        }
    }
    else if([path isEqualToString:GROUP_QUERY_TICKETS_PARAMTER]){
        if ([json isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)json;
            NSDictionary *d = [array lastObject];
            
            NSString *orderID = [d valueForKey:@"order_id"];
            
            NSString *ticketID = [d valueForKey:@"ticket_number"];
            
            NSString *ticketPassword = [d valueForKey:@"ticket_pwd"];
            
            NSString *ticketExpirationDate = [d valueForKey:@"expiration_date"];
            
            NSString *ticketStatus = [d valueForKey:@"ticket_status"];
               
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(orderID=%@)",orderID];
            
            
            NSArray *objects = [[Utility sharedObject] getQueryObjectByPredicate:predicate entityForName:@"OrderEntity"];
            
            if ([objects count] > 0) {
                    OrderEntity *o = [objects objectAtIndex:0];
                    o.ticketID = ticketID;
                    o.ticketPassword = ticketPassword;
                    o.expirationDate = ticketExpirationDate;
                    o.orderStatus = ticketStatus;
                    
            
            }
            
        }
        else if ([json isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *d = (NSDictionary *)json;
            NSLog(@"@124,%@",d);
        }
        
        MOrderDetailController *controller =  [[[MOrderDetailController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
        controller.orderID = orderID;
        
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    
    [[Utility sharedObject] saveSharedContext];
    
}

#pragma mark -- load table view data

-(void)loadDataFromDB
{
    NSManagedObjectContext *context = [(RococoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OrderEntity" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    
    self.orderEntitys = results;
    [request release];
    
    [self.tableView reloadData];
}

-(void) refreshTableView
{
    //search all order first
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [hud setLabelText:@"请稍后"];
    
    [hud setDetailsLabelText:@"正在读取数据..."];
    
    [hud setSquare:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        NSManagedObjectContext *context = [(RococoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"OrderEntity" inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSArray *results = [context executeFetchRequest:request error:nil];
        
        for (OrderEntity *e in results) {
            
            NSDate *date = [NSDate date];
            
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
            
            [formater setDateFormat:@"yyyy-MM-dd"];
            
            NSString *strToday = [formater stringFromDate:date];
            
            NSString *strURL = [NSString stringWithFormat:@"%@%@/?order_id=%@&begin_date=%@&end_date=%@",API_BASE_URL,GROUP_ORDER_LIST_PARAMTER,e.orderID,strToday,strToday];
            
            NSURL *url = [NSURL URLWithString:strURL];
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if ([json isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)json;
                e.orderStatus = [dict valueForKey:@"status"];
                [context save:nil];
                //update to database
            }
            
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadDataFromDB];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
           
        
        });
    
    });
    
    
    
    
    
    
}

#pragma mark -- viewcontroller
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
	// Do any additional setup after loading the view.

    // Remove table cell separator
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIBarButtonItem *refreshItem  = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTableView)] autorelease];
    
    self.navigationItem.rightBarButtonItem = refreshItem;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadDataFromDB];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.orderEntitys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSInteger row = [indexPath row];
    OrderEntity *o = [self.orderEntitys objectAtIndex:row];
    
    if (cell == nil) {
        cell = [[[MOrderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
        UIFont *font = [UIFont systemFontOfSize:13];
        UIFont *italicFont = [UIFont italicSystemFontOfSize:13];
        
        UILabel *productLabel = [[[UILabel alloc] init] autorelease];
        
        
        
        productLabel.text = o.productName;
        
        productLabel.backgroundColor = [UIColor clearColor];
        
        productLabel.frame = CGRectMake(20, 15, 280, 20);
        
        [cell addSubview:productLabel];
        
        UILabel *statusLabel = [[[UILabel alloc] init] autorelease];
        
        statusLabel.text = o.orderStatus;
        
        statusLabel.backgroundColor = [UIColor clearColor];
        
        statusLabel.textColor = [UIColor grayColor];
        
        statusLabel.frame = CGRectMake(20, 40, 100, 20);
        
        [cell addSubview:statusLabel];
        
        UILabel *priceLabel = [[[UILabel alloc] init]autorelease];
        
        priceLabel.text = [NSString stringWithFormat:@"¥ %@",o.orderPrice];
        
        priceLabel.textColor = [UIColor orangeColor];
        
        priceLabel.backgroundColor= [UIColor clearColor];
        
        [priceLabel setFrame:CGRectMake(240, 40, 100, 20)];
        
        [cell addSubview:priceLabel];
        
        [productLabel setFont:font];
        [statusLabel setFont:font];
        [priceLabel setFont:italicFont];
        
        productLabel.tag = 101;
        statusLabel.tag = 102;
        priceLabel.tag = 103;
    }
    else
    {
        UILabel *productLabel = (UILabel *)[cell viewWithTag:101];
        productLabel.text = o.productName;
        
        UILabel  *statusLabel = (UILabel *)[cell viewWithTag:102];
        statusLabel.text = o.orderStatus;
        
        UILabel *priceLabel = (UILabel *)[cell viewWithTag:103];
        priceLabel.text = [NSString stringWithFormat:@"¥ %@",o.orderPrice];
    }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;

    
    return cell;
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    OrderEntity *o = [self.orderEntitys objectAtIndex:row];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString *strToday = [formater stringFromDate:date];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@/?order_id=%@&begin_date=%@&end_date=%@",API_BASE_URL,GROUP_ORDER_LIST_PARAMTER,o.orderID,strToday,strToday];
    
    
    [self.network httpJsonResponse:strURL byController:self];
}


@end
