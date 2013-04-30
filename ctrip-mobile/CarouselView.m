//
//  CarouselView.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-19.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "CarouselView.h"
#import "iCarousel.h"
#import "UIImageView+AFNetworking.h"
@interface CarouselView () <iCarouselDataSource, iCarouselDelegate>
@property (nonatomic,retain) iCarousel *carousel;
@end

@implementation CarouselView

@synthesize carousel;
@synthesize items;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        carousel = [[iCarousel alloc] initWithFrame:self.bounds];
        carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        carousel.type = iCarouselTypeInvertedTimeMachine;
        carousel.delegate = self;
        carousel.dataSource = self;
    }
    return self;
}

-(void)dealloc{
    self.carousel = nil;
    carousel.delegate = nil;
    carousel.dataSource = nil;
    [carousel release];
    [items release];
    [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImageView *backgroundView = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
	backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	backgroundView.image = [UIImage imageNamed:@"background.png"];
	[self addSubview:backgroundView];
    
    [self addSubview:carousel];
    [carousel reloadData];
}

#pragma mark -
#pragma mark -icarousel delegate methods
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        NSURL *url=[NSURL URLWithString: [items objectAtIndex:index]];
        
        view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)] autorelease];
        
        [((UIImageView *)view) setImageWithURL:url];
        
        NSLog(@"url:%@",url);
        NSLog(@"width:%.0f height:%.0f",view.frame.size.width,view.frame.size.height);
        
        view.contentMode = UIViewContentModeCenter;
    }
    
    return view;
}
- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}


@end
