//
//  MItemCell.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-17.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MItemCell : UITableViewCell

@property(nonatomic,retain) IBOutlet UILabel *nameLabel;
@property(nonatomic,retain) IBOutlet UILabel *priceLabel;
@property(nonatomic,retain) IBOutlet UILabel *descLabel;
@property(nonatomic,retain) IBOutlet UIImageView *thumbnailView;
@end
