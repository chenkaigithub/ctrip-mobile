//
//  RococoAppDelegate.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-11.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MItemListController;

@interface RococoAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MItemListController *viewController;

@end
