//
//  MNetWork.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-19.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol jsonDelegate <NSObject>

-(void) setJson:(id)json;

@end

@interface MNetWork : NSObject

@property (assign,nonatomic) id<jsonDelegate> delegate;

-(void)getJsonDataWithURL:(NSString *)str;

@end
