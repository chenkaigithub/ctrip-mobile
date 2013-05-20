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
#import "Const.h"

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
    
    if ([path isEqualToString:GROUP_CANCEL_TICKETS_PARAMTER]) {
        if ([json isKindOfClass:[NSDictionary class]]) {
            if ([json objectForKey:@"error_msg"]) {
                [[Utility sharedObject] setAlertView:[json objectForKey:@"error_msg"] withMessage:nil];
                return;
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ticketID = %@)",self.order.ticketID];
            
            NSArray *objects = [[Utility sharedObject] getQueryObjectByPredicate:predicate entityForName:@"OrderEntity"];
            
            if ([objects count]>0) {
                
                OrderEntity *o = [objects objectAtIndex:0];
                
                NSDictionary *data = (NSDictionary *)json;
                
                o.orderStatus = [data valueForKey:@"ticket_status"];
                 
            }
                       
            [[Utility sharedObject] saveSharedContext];
            
                       
            [self loadDataFromDB];
            [[Utility sharedObject] setAlertView:@"申请退款成功。" withMessage:nil];
            
            return;
        }
        
    }
    
    MItemDetailController *controller = [[[MItemDetailController alloc] init] autorelease];
    
    ItemDetail *detail = [[[ItemDetail alloc] initWithDictionary:(NSDictionary *)json]autorelease];
    
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
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(orderID = %@)",self.orderID];
    
    NSArray *objects = [[Utility sharedObject]getQueryObjectByPredicate:predicate entityForName:@"OrderEntity"];
    
    if ([objects count]>0) {
        
        OrderEntity *o = [objects objectAtIndex:0];
        
        self.order = o;
        
    }
    
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadDataFromDB];

    self.title = @"订单详情";
    
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
        if (self.order.ticketID == nil ||self.order.ticketID.length == 0) {
            return 5;
        }
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
        
        NSString *url = [NSString stringWithFormat:@"%@%@/?product_id=%@",API_BASE_URL,GROUP_PRODUCT_PARAMTER,self.order.productID];
        
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
                    NSString *url = [NSString stringWithFormat:@"%@%@/?ticket_no=%@",API_BASE_URL,GROUP_CANCEL_TICKETS_PARAMTER,self.order.ticketID];
                    [self.network httpJsonResponse:url byController:self];
                };
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您真的要退款吗？" message:nil cancelButtonItem:cancelItem otherButtonItems:okItem, nil];
                [alert show];
                [alert release];
            }
            else if([self.order.orderStatus isEqualToString:@"未提交"]){
                okItem.action = ^{
                    NSString *url = [NSString stringWithFormat:@"%@%@/?business_type=Tuan&order_type=6&description=%@&order_id=%@",API_BASE_URL,PAYMENT_PARAMTER,[self.order.productName URLEncode],self.order.orderID];
                    NSLog(@"312,%@",url);
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
