//
//  Item.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-17.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "Item.h"
#import "NSString+Category.h"

@implementation Item

@synthesize productID;
@synthesize name;
@synthesize price;
@synthesize desc;
@synthesize thumbnailURL;

-(id) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.name = [dictionary valueForKey:@"name"];
        self.price = [dictionary valueForKey:@"price"];
        self.thumbnailURL = [dictionary valueForKey:@"img"];
        self.productID = [[dictionary valueForKey:@"product_id"] integerValue];
        self.desc = [[dictionary valueForKey:@"description"] stringByConvertingHTMLToPlainText];
    }
    return self;
}


@end
