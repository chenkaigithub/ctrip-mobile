//
//  MItemDetailController.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-19.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MItemDetailController.h"
#import "MDetailCell.h"
#import "NSString+Category.h"
#import "MOrderCreateController.h"
#import "MMapController.h"
#import "TOrder.h"
#import "UIImageView+AFNetworking.h"
#import "Const.h"
#import <QuartzCore/QuartzCore.h>
@interface MItemDetailController ()

@property (nonatomic,retain)NSArray *cellHeightValues;
@end

@implementation MItemDetailController{
    
}

@synthesize detail =_detail;
@synthesize cellHeightValues = _cellHeightValues;



-(void)setJSON:(id)json fromRequest:(NSURLRequest *)request
{

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)orderProduct
{
    TOrder *order = [[[TOrder alloc] init]autorelease];
    order.productID = [ NSString stringWithFormat:@"%d",self.detail.productID];
    order.productName = self.detail.name;
    order.price = self.detail.price;
    
    MOrderCreateController *controller = [[[MOrderCreateController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    
    controller.order = order;
    
    [self.navigationController pushViewController:controller animated:YES];
    
}
-(void)share
{
    NSString *shareURL = self.detail.oURL;
    NSArray *shareObjects = [NSArray arrayWithObjects:shareURL, nil];
    UIActivityViewController *controller = [[[UIActivityViewController alloc] initWithActivityItems:shareObjects applicationActivities:nil] autorelease];
    
    controller.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:controller animated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add padding to the top of the table view
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.contentInset = inset;
    //back button
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil] autorelease];
    
    self.navigationItem.backBarButtonItem =backButton;
    
    //share button
    NSLog(@"version:%@",[[UIDevice currentDevice] systemVersion]);
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (systemVersion>6.0) {
        UIBarButtonItem *barItem = [[[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleBordered target:self action:@selector(share)] autorelease];
        
        self.navigationItem.rightBarButtonItem = barItem;
    }
        
    
    
    
    self.title = @"酒店详情";//self.detail.name;
    
    UILabel *hiddenLabel = [[[UILabel alloc] init] autorelease];
    
    hiddenLabel.text = [self.detail.headDesc stringByConvertingHTMLToPlainText];
    CGFloat h1 = [self getLabelHeight:hiddenLabel];
    
    hiddenLabel.text = [self.detail.desc stringByConvertingHTMLToPlainText];
    
    CGFloat h2 = [self getLabelHeight:hiddenLabel];
    
    hiddenLabel.text = [self.detail.ruleDesc stringByConvertingHTMLToPlainText];
    
    CGFloat h3 = [self getLabelHeight:hiddenLabel];
    
    
    self.cellHeightValues = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:h1],
                        [NSNumber numberWithFloat:h2],
                        [NSNumber numberWithFloat:h3],
                        nil];
    
    
    // Do any additional setup after loading the view.
}

-(CGRect)getResizeFrame:(UILabel *)label
{
    [label setLineBreakMode:UILineBreakModeWordWrap];
    [label setNumberOfLines:0];
    [label setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    
    CGSize labelSize = [label.text sizeWithFont:label.font
                              constrainedToSize:CGSizeMake(320, 999)
                                  lineBreakMode:label.lineBreakMode];
    
    CGFloat labelHeight = labelSize.height;
    
    label.frame=CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, labelHeight);
    
    return label.frame;
}

-(CGFloat)getLabelHeight:(UILabel *)label
{
    
    CGRect rect = [self getResizeFrame:label];
   
    return rect.size.height;
        
}



-(void)dealloc
{
    [_cellHeightValues release];
    [_detail release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark xlcycle delegate

-(NSInteger)numberOfPages
{
    return self.detail.imageDictList.count;
    //return self.detail.imageList.count ;
}

-(UIView *) pageAtIndex:(NSInteger)index
{
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 180)] autorelease];
    
    NSDictionary *dict = [self.detail.imageDictList objectAtIndex:index];
    
    NSString *str = [NSString stringWithFormat:@"%@%d/?url=%@",THUMBNAIL_URL,THUMBNAIL_IMAGE_WIDTH,[(NSString *)[dict objectForKey:@"url"] URLEncode]];
    
    NSURL *url = [NSURL URLWithString:str];
    
    [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    CALayer *layer = [imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:7.0];
    
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)]autorelease];
    view.backgroundColor = [UIColor grayColor];
    [view addSubview:imageView];
   
    return view;
}

#pragma mark table view delegate and datasource

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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < 5) {
        return 1;
    }
    
   
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row  =[indexPath row];
    NSUInteger section =  [indexPath section];
    NSString *cellIdentify = [NSString stringWithFormat:@"cell%d%d",row,section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    

    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        
        
        
        if (section == 0) {
            XLCycleScrollView *csView = [[[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)] autorelease];
            csView.datasource =self;
            csView.delegate = self;
            csView.backgroundColor = [UIColor grayColor];
            [cell addSubview:csView];
        }
        
        if (section == 1) {
            cell.textLabel.text = self.detail.name;
        }
        
        if (section < 5) {
            [cell.textLabel setFrame:[self getResizeFrame:cell.textLabel]];
            
        }
        
        
        if (section == 2 && row ==0) {
            cell.textLabel.text = [self.detail.headDesc stringByConvertingHTMLToPlainText];
            
        }
        
        if (section == 3 && row == 0) {
            cell.textLabel.text = [self.detail.desc stringByConvertingHTMLToPlainText];
        }
        
        if (section == 4 && row == 0) {
            cell.textLabel.text = [self.detail.ruleDesc stringByConvertingHTMLToPlainText];
            
        }
        
        if (section == 5) {
            switch (row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"价格：¥ %@",self.detail.price];
                    cell.textLabel.textColor = [UIColor orangeColor];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 1:
                    if (self.detail.address.length >0) {
                        cell.textLabel.text = [NSString stringWithFormat:@"地址：%@",self.detail.address];
                        
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                    else
                    {
                        cell.textLabel.text = @"地址：- -";
                    }
                    break;
                case 2:
                    
                    if (self.detail.tel.length>0) {
                        cell.textLabel.text = [NSString stringWithFormat:@"电话：%@", self.detail.tel];
                        
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                    else
                    {
                        cell.textLabel.text = @"电话：- -";
                    }
                    break;
                default:
                    break;
            }
        }
        
    }
    
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return @"描述";
    }
    
    if (section == 3) {
        return @"包含项目";
    }
    
    if (section == 4) {
        return @"特别提示";
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger section = [indexPath section];
    //int row = [indexPath row];
    if (section == 0) {
        return 220;
    }
    
    if (section == 2) {
        return [[self.cellHeightValues objectAtIndex:0] floatValue ]+20;
    }
    
    if (section == 3) {
        return [[self.cellHeightValues objectAtIndex:1] floatValue]+20;
    }
    
    if (section == 4) {
        return [[self.cellHeightValues objectAtIndex:2] floatValue]+20;
    }
    
    return 44;
    
    //return newHeight+15;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    int section = [indexPath section];
    
    if (section == 5 && row == 1) {
        //address view
        MMapController *controller = [[[MMapController alloc] init] autorelease];
        
        controller.name = [NSString stringWithString:self.detail.name];
        controller.address = [NSString stringWithString:self.detail.address];
        controller.coordinate = self.detail.location;
        
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    
    if (section == 5 && row ==0) {
        [self orderProduct];
    }
    
    if (section == 5 && row == 2) {
        
        NSString *num = self.detail.tel;
        UIAlertView *alert =[ [UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"是否确认拨打：%@",num] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert show];
        
        [alert release];
        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
    
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.detail.tel]]];
    }
}
@end
