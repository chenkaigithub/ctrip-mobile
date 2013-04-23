//
//  MItemDetailController.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-19.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MItemDetailController.h"
#import "MDetailCell.h"
#import "NSString+URLEncoding.h"

@interface MItemDetailController ()

@property (nonatomic,retain)NSArray *cellHeightValues;
@end

@implementation MItemDetailController{
    
}

@synthesize carouselView=_carouselView;
@synthesize tableView=_tableView;
@synthesize detail =_detail;
@synthesize cellHeightValues = _cellHeightValues;
-(void)setJson:(id)json {

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

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *btnDone = [[[UIBarButtonItem alloc] initWithTitle:@"预定" style:UIBarButtonItemStyleBordered target:self action:@selector(orderProduct)] autorelease];
    
    self.navigationItem.rightBarButtonItem = btnDone;
    
    self.carouselView = [[[CarouselView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)]autorelease];
    self.carouselView.items = self.detail.imageList;
    
    [self.view addSubview:self.carouselView];
    
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 240, 320, 240)]autorelease];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = self.detail.name;
    
    
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

-(CGFloat)getLabelHeight:(UILabel *)label
{
    [label setLineBreakMode:UILineBreakModeWordWrap];
    [label setNumberOfLines:0];
    [label setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    
    CGSize labelSize = [label.text sizeWithFont:label.font
                              constrainedToSize:CGSizeMake(200, 999)
                                  lineBreakMode:label.lineBreakMode];
    
    CGFloat labelHeight = labelSize.height;
    
    label.frame=CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, labelHeight);
    
   
    return label.frame.size.height;
        
}
-(void)dealloc
{
    [_cellHeightValues release];
    [_carouselView release];
    [_tableView release];
    [_detail release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row  =[indexPath row];
    NSString *cellIdentify = [NSString stringWithFormat:@"cell%d",row];
    
    MDetailCell *cell = (MDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MDetailCell" owner:self options:nil];
        cell = (MDetailCell *)[nib objectAtIndex:0];
        
        switch (row) {
            case 0:
                cell.titleLabel.text = @"描述:";
                cell.detailLabel.text = [self.detail.headDesc stringByConvertingHTMLToPlainText];
                break;
            case 1:
                cell.titleLabel.text =@"包含项目:";
                cell.detailLabel.text = [self.detail.desc stringByConvertingHTMLToPlainText];
                break;
            case 2:
                cell.titleLabel.text =@"特别提示:";
                cell.detailLabel.text =[self.detail.ruleDesc stringByConvertingHTMLToPlainText];
                break;
            case 3:
                cell.titleLabel.text = @"价格:";
                cell.detailLabel.text = self.detail.price;
                break;
            case 4:
                cell.titleLabel.text =@"地址:";
                cell.detailLabel.text =self.detail.address;
                break;
            case 5:
                cell.titleLabel.text = @"电话:";
                cell.detailLabel.text = self.detail.tel;
                break;
            default:
                break;
        }
    }
       
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    
    CGFloat newHeight = 44;
    
    switch (row) {
        case 0:
            newHeight = [[self.cellHeightValues objectAtIndex:0] floatValue];
            break;
        case 1:
            newHeight = [[self.cellHeightValues objectAtIndex:1] floatValue];
            break;
        case 2:
            newHeight = [[self.cellHeightValues objectAtIndex:2] floatValue];
            break;
        default:
            break;
    }
     
    if (newHeight+15 < 44) {
        return 44;
    }
    
    if (row>2) {
        
        return 44;
    }
    
    return newHeight+15;
    
}



@end
