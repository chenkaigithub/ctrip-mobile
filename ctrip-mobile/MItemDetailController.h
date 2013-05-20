//
//  MItemDetailController.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-19.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNetWork.h"
#import "ItemDetail.h"
#import "MBaseController.h"
#import "XLCycleScrollView.h"
@interface MItemDetailController :UITableViewController <UIAlertViewDelegate,jsonDelegate,XLCycleScrollViewDatasource,XLCycleScrollViewDelegate>

@property (retain,nonatomic)ItemDetail *detail;
@end
