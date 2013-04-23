//
//  MDetailCell.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-23.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MDetailCell.h"

@implementation MDetailCell

@synthesize detailLabel;
@synthesize titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) layoutSubviews
{
    
    
    [super layoutSubviews];
    
    [self resizeLabel:self.titleLabel fitSize:NO];
    [self resizeLabel:self.detailLabel fitSize:NO];

    
}

-(void)resizeLabel:(UILabel *)label fitSize:(BOOL) fitSize
{
   
    CGSize labelSize = [label.text sizeWithFont:label.font
                            constrainedToSize:CGSizeMake(200, CGFLOAT_MAX)
                                lineBreakMode:label.lineBreakMode];
    
    CGFloat labelHeight = labelSize.height;
    
    label.frame=CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, labelHeight);
    
    if (fitSize == YES) {
        [label sizeToFit];
        
    }
    
}
@end
