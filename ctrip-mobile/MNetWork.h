//
//  MNetWork.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-19.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNetWork : NSObject
-(void)getJsonDataWithURL:(NSString *)str doSomeThing:(id)function;
@end
