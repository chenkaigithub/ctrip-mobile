//
//  TOrder.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-24.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOrder : NSObject
//required data
@property (nonatomic,retain) NSString *productID;
@property (nonatomic,retain) NSString *productName;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *mobile;
@property (nonatomic,retain) NSString *quantity;

@property (nonatomic,retain) NSString *price;
//return data
@property (nonatomic,retain) NSString *amount;
@property (nonatomic,retain) NSString *status;
@property (nonatomic,retain) NSString *orderID;
@property (nonatomic,retain) NSString *createTime;

@end
