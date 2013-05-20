//
//  Item.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-17.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic,assign) NSUInteger productID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *price;
@property (nonatomic,retain) NSString *desc;
@property (nonatomic, retain) NSString *thumbnailURL;

-(id)initWithDictionary:(NSDictionary *)dictionary;
@end
