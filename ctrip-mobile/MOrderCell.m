//
//  MOrderCell.m
//  ctrip-mobile
//
//  Created by cao guangyao on 13-5-5.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MOrderCell.h"

@implementation MOrderCell

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
- (void)willTransitionToState:(UITableViewCellStateMask)state {
    
    [super willTransitionToState:state];
    
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
        
        for (UIView *subview in self.subviews) {
            
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
                
                subview.hidden = YES;
                subview.alpha = 0.0;
            }
        }
    }
}
- (void)didTransitionToState:(UITableViewCellStateMask)state {
    
    [super didTransitionToState:state];
    
    if (state == UITableViewCellStateShowingDeleteConfirmationMask || state == UITableViewCellStateDefaultMask) {
        for (UIView *subview in self.subviews) {
            
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
                
                UIView *deleteButtonView = (UIView *)[subview.subviews objectAtIndex:0];
                CGRect f = deleteButtonView.frame;
                f.origin.x -= 10;
                deleteButtonView.frame = f;
                
                subview.hidden = NO;
                
                [UIView beginAnimations:@"anim" context:nil];
                subview.alpha = 1.0;
                [UIView commitAnimations];
            }
        }
    }
}

@end
