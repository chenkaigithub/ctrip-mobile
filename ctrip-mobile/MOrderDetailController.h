//
//  MOrderDetailController.h
//  ctrip-mobile
//
//  Created by cao guangyao on 13-5-5.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MBaseController.h"
#import "OrderEntity.h"
@interface MOrderDetailController : MBaseController
@property (nonatomic,retain) NSString *orderID;

-(void)loadDataFromDB;
@end
