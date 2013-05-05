//
//  OrderEntity.h
//  ctrip-mobile
//
//  Created by cao guangyao on 13-5-5.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrderEntity : NSManagedObject

@property (nonatomic, retain) NSString * expirationDate;
@property (nonatomic, retain) NSString * orderID;
@property (nonatomic, retain) NSString * ticketPassword;
@property (nonatomic, retain) NSString * productID;
@property (nonatomic, retain) NSString * productName;
@property (nonatomic, retain) NSString * orderStatus;
@property (nonatomic, retain) NSString * ticketID;
@property (nonatomic, retain) NSString * orderEmail;
@property (nonatomic, retain) NSString * orderTel;
@property (nonatomic, retain) NSString * orderQuantity;
@property (nonatomic, retain) NSString * orderPrice;

@end
