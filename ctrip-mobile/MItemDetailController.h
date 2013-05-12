//
//  MItemDetailController.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-19.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNetWork.h"
#import "CarouselView.h"
#import "ItemDetail.h"
#import "MBaseController.h"
@interface MItemDetailController :MBaseController <UIAlertViewDelegate,jsonDelegate>

@property (retain,nonatomic)CarouselView *carouselView;
@property (retain,nonatomic)ItemDetail *detail;
@end
