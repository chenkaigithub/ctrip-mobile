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
@interface MMyOrderController ()

@property (nonatomic,retain) NSMutableArray *orderEntitys;
@end

@implementation MMyOrderController
@synthesize orderEntitys=_orderEntitys;

#pragma mark -- network delegate
-(void)setJson:(id)json
{
    NSManagedObjectContext *context = [(RococoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OrderEntity" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *data = (NSDictionary *)json;
        
        
        
        if ([data objectForKey:@"error_msg"]) {
            [[Utility sharedObject] setAlertView:[data valueForKey:@"error_msg"] withMessage:nil];
            //return;
        }
        /*
            NSString *dataTicketID = [data valueForKey:@"ticket_number"];
            NSString *dataTicketStatus = [data valueForKey:@"ticket_status"];
        
            NSLog(@"@32,cancel ticket:ticket_number:%@,\nticket_status%@",dataTicketID,dataTicketStatus);
        
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ticketID = %@)",dataTicketID];
            
            [request setPredicate:predicate];
            
            NSError *error;
            
            NSArray *objects = [context executeFetchRequest:request error:&error];
            
            if ([objects count]==0) {
                NSLog(@"no matches");
            }
            else{
                OrderEntity *o = [objects objectAtIndex:0];
                
                if (dataTicketStatus.length > 0) {
                    o.orderStatus = dataTicketStatus;
                }
            }
         */
        
    }
    if ([json isKindOfClass:[NSArray class]]) {
        
        NSDictionary *data = (NSDictionary *)[json lastObject];
        
        NSString *orderID = [data valueForKey:@"order_id"];
        NSString *ticketID = [data valueForKey:@"ticket_number"];
        NSString *ticketPassword = [data valueForKey:@"ticket_pwd"];
        NSString *ticketExpirationDate = [data valueForKey:@"expiration_date"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(orderID=%@)",orderID];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        if ([objects count] == 0) {
            NSLog(@"no matches");
        }
        else{
            OrderEntity *o = [objects objectAtIndex:0];
            o.ticketID = ticketID;
            o.ticketPassword = ticketPassword;
            o.expirationDate = ticketExpirationDate;
        }
        
        MOrderDetailController *controller =  [[[MOrderDetailController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
        
        [self.navigationController pushViewController:controller animated:YES];
        
        //NSString *strURL = [NSString stringWithFormat:@"http://ctrip.herokuapp.com/api/group_cancel_tickets/?ticket_no=%@",ticketID];
        
    }
    [request release];
    NSError *error;
    
    if (![context save:&error]) {
        NSLog(@"error!");
    }else {
        NSLog(@"save order ok.");
    }

}

#pragma mark -- load table view data

-(void)loadDataFromDB
{
    NSManagedObjectContext *context = [(RococoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OrderEntity" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    self.orderEntitys = [[NSMutableArray alloc] init];
    
    for (id object in results) {
        if ([object isKindOfClass:[OrderEntity class]]) {
            OrderEntity *o = (OrderEntity *)object;
            NSLog(@"@48,%@",o);
            [self.orderEntitys addObject:o];
        }
    }
    
    [request release];
    
    [self.tableView reloadData];
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
    
    if (cell == nil) {
        cell = [[[MOrderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
        OrderEntity *o = [self.orderEntitys objectAtIndex:row];
        
        cell.textLabel.text = o.productName;
        cell.detailTextLabel.text = o.orderStatus;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    // Configure the cell...
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
    
    NSString *strURl = [NSString stringWithFormat:@"http://ctrip.herokuapp.com/api/group_query_tickets/?order_id=%@",o.orderID];
    
    [self.network httpJsonResponse:strURl byController:self];
}


@end
