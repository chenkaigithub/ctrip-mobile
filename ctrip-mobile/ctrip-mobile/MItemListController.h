//
//  MItemListController.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-12.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MBaseController.h"
@interface MItemListController : MBaseController<MBProgressHUDDelegate,UIActionSheetDelegate>{
    MBProgressHUD *hudView;
}
@property (retain,nonatomic) NSString *keyWords;
@property(retain, nonatomic) NSMutableArray *items;
@property(assign,nonatomic) NSUInteger itemTotalCount;
@end
