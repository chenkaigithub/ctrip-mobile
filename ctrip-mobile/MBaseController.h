//
//  MBaseController.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-17.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNetWork.h"
@interface MBaseController : UITableViewController<jsonDelegate>

@property (retain,nonatomic)MNetWork *network;

@end
