//
//  MOrderDetailController.m
//  ctrip-mobile
//
//  Created by cao guangyao on 13-5-5.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MOrderDetailController.h"
#import "MItemDetailController.h"
#import "NSString+Category.h"
#import "UIAlertView+Blocks.h"
#import "RococoAppDelegate.h"
#import "Utility.h"
@interface MOrderDetailController ()
@property (nonatomic,retain)OrderEntity *order;
@end

@implementation MOrderDetailController
@synthesize orderID = _orderID;
@synthesize order = _order;

-(void)setJSON:(id)json fromRequest:(NSURLRequest *)request
{
    NSURL *url = [request URL];
    NSString *path = [url path];
    
    if ([path isEqualToString:@"/api/group_cancel_tickets"]) {
        if ([json isKindOfClass:[NSDictionary class]]) {
            if ([json objectForKey:@"error_msg"]) {
                [[Utility sharedObject] setAlertView:[json objectForKey:@"error_msg"] withMessage:nil];
                return;
            }
            NSManagedObjectContext *context =[(RococoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"OrderEntity" inManagedObjectContext:context];
            [fetchRequest setEntity:entity];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ticketID = %@)",self.order.ticketID];
            
            [fetchRequest setPredicate:predicate];
            
            NSError *error;
            
            NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
            
            if ([objects count]==0) {
                NSLog(@"no matches");
            }
            else{
                OrderEntity *o = [objects objectAtIndex:0];
                
                NSDictionary *data = (NSDictionary *)json;
                
                NSLog(@"@53,%@",data);
                
                o.orderStatus = [data valueForKey:@"ticket_status"];
                
                
            }
            NSError *e;
            
            if (![context save:&e]) {
                NSLog(@"error!");
            }else {
                NSLog(@"save order ok.");
            }

            [fetchRequest release];
            [self loadDataFromDB];
            [[Utility sharedObject] setAlertView:@"申请退款成功。" withMessage:nil];
            
            return;
        }
        
    }
    
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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadDataFromDB
{
    NSManagedObjectContext *context =[(RococoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OrderEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(orderID = %@)",self.orderID];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([objects count]==0) {
        NSLog(@"no matches");
    }
    else{
        OrderEntity *o = [objects objectAtIndex:0];
        
        self.order = o;
        
    }
    [fetchRequest release];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadDataFromDB];

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
    [self.orderID release];
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
        return 8;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",[indexPath row],[indexPath section]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    if (section == 0 && row == 0) {
        
        cell.textLabel.text = self.order.productName;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (section == 1) {
        
        switch (row) {
            case 0:
                cell.textLabel.text = @"订单状态";
                cell.detailTextLabel.text = self.order.orderStatus;
                if ([self.order.orderStatus isEqualToString:@"未提交"]||[self.order.orderStatus isEqualToString:@"支付成功"]) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                break;
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
                break;
            case 7:
                cell.textLabel.text = @"过期时间";
                cell.detailTextLabel.text = self.order.expirationDate;
            default:
                break;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    if (section == 0 && row == 0) {
        //MItemDetailController *controller =  [[[MItemDetailController alloc] init]autorelease];
        
        NSString *url = [NSString stringWithFormat:@"http://ctrip.herokuapp.com/api/group_product_info/?product_id=%@",self.order.productID];
        
        [self.network httpJsonResponse:url byController:self];
    }
    
    if (section == 1 && row == 0 ) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
            //go to payment page
            RIButtonItem *okItem = [RIButtonItem item];
            okItem.label = @"确定";
            
            RIButtonItem *cancelItem = [RIButtonItem item];
            cancelItem.label = @"取消";
            
            if ([self.order.orderStatus isEqualToString:@"支付成功"]) {
                okItem.action = ^{
                    NSString *url = [NSString stringWithFormat:@"http://ctrip.herokuapp.com/api/group_cancel_tickets/?ticket_no=%@",self.order.ticketID];
                    [self.network httpJsonResponse:url byController:self];
                };
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您真的要退款吗？" message:nil cancelButtonItem:cancelItem otherButtonItems:okItem, nil];
                [alert show];
                [alert release];
            }
            else{
                okItem.action = ^{
                    NSString *url = [NSString stringWithFormat:@"http://ctrip.herokuapp.com/api/get_payment/?business_type=Tuan&order_type=6&description=%@&order_id=%@",[self.order.productName URLEncode],self.order.orderID];
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                    
                };
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"即将打开Safari\n前往支付页面，是否继续？" message:nil cancelButtonItem:cancelItem otherButtonItems:okItem, nil];
                
                [alert show];
                [alert release];
            }
            
            
            
            
            
        }
    }
    
}

@end
