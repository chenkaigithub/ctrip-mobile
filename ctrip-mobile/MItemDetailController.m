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

@end

@implementation MItemDetailController

@synthesize carouselView=_carouselView;
@synthesize tableView=_tableView;
@synthesize detal =_detal;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.carouselView = [[[CarouselView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)]autorelease];
    self.carouselView.items = self.detal.imageList;
    
    [self.view addSubview:self.carouselView];
    
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 240, 320, 240)]autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    
    self.title = self.detal.name;
    
    // Do any additional setup after loading the view.
}

-(void)dealloc
{
    [_carouselView release];
    [_tableView release];
    [_detal release];
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
                cell.titleLabel.text = @"描述";
                cell.detailLabel.text = [self.detal.headDesc stringByConvertingHTMLToPlainText];
                break;
            case 1:
                cell.titleLabel.text =@"包含项目";
                cell.detailLabel.text = [self.detal.desc stringByConvertingHTMLToPlainText];
                break;
            case 2:
                cell.titleLabel.text =@"特别提示";
                cell.detailLabel.text =[self.detal.ruleDesc stringByConvertingHTMLToPlainText];
                break;
            case 3:
                cell.titleLabel.text = @"价格";
                cell.detailLabel.text = self.detal.price;
                break;
            case 4:
                cell.titleLabel.text =@"地址";
                cell.detailLabel.text =self.detal.address;
                break;
            case 5:
                cell.titleLabel.text = @"电话";
                cell.detailLabel.text = self.detal.tel;
                break;
            default:
                break;
        }
    
    if (row<3) {
        cell.detailLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
        cell.detailLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        cell.detailLabel.numberOfLines = 0;
        
        CGSize labelSize = [cell.detailLabel.text sizeWithFont:cell.detailLabel.font
                                             constrainedToSize:CGSizeMake(200, CGFLOAT_MAX)
                                                 lineBreakMode:UILineBreakModeCharacterWrap];
        
        CGFloat labelHeight = labelSize.height;
        
        [cell.detailLabel setBackgroundColor:[UIColor orangeColor]];
        [cell.detailLabel setNumberOfLines:0];
        [cell.detailLabel setFrame:CGRectMake(cell.detailLabel.frame.origin.x, cell.detailLabel.frame.origin.y, cell.detailLabel.frame.size.width, labelHeight)];
        //NSLog(@"%f",self.detailLabel.frame.size.height);

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
    return 71;
}

@end
