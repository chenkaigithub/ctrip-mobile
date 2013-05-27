//
//  ItemDetail.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-22.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "ItemDetail.h"

@implementation ItemDetail

@synthesize productID;
@synthesize name;
@synthesize desc;
@synthesize ruleDesc;
@synthesize headDesc;
@synthesize price;
@synthesize address;
@synthesize tel;
@synthesize location;
@synthesize imageList;
@synthesize imageDictList;
@synthesize oURL;

@synthesize descList;
@synthesize ruleDescList;
@synthesize headDescList;

-(id) initWithDictionary:(NSDictionary *)dictionary
{
    
    self = [super init];
    if (self) {
        // Custom initialization
        
        self.productID = [[dictionary valueForKey:@"product_id"] integerValue];
        self.name =[dictionary valueForKey:@"name"];
        
        self.desc = [dictionary valueForKey:@"description"];
        self.ruleDesc = [dictionary valueForKey:@"rule_description"];
        self.headDesc = [dictionary valueForKey:@"head_description"];
        
        self.tel = [dictionary valueForKey:@"tel"];
        self.price = [dictionary valueForKey:@"price"];
        self.address = [dictionary valueForKey:@"address"];
        
        CLLocationCoordinate2D loaction;
        
        loaction.latitude = [[dictionary valueForKey:@"lat"] floatValue];
        loaction.longitude = [[dictionary valueForKey:@"lon"] floatValue];
        
        self.location = loaction;
        
        NSArray *images = [[[NSArray alloc] init] autorelease];
        
        NSArray *list = [dictionary objectForKey:@"pictures"];
        
        for (id object in list) {
            
            NSString * url = [object valueForKey:@"url"];
            
            images = [images arrayByAddingObject:url];
        }
        
        NSArray *imageObjects  = [dictionary objectForKey:@"image_list"];
        self.imageDictList = [NSArray arrayWithArray:imageObjects];
        self.imageList = images;
        self.oURL = [dictionary valueForKey:@"ourl"];
        
        self.descList = [dictionary objectForKey:@"description_list"];
        self.headDescList = [dictionary objectForKey:@"head_description_list"];
        self.ruleDescList = [dictionary objectForKey:@"rule_description_list"];
    }

    return self;

}
@end
