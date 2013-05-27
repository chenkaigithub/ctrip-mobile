//
//  MDescriptionController.m
//  ctrip-mobile
//
//  Created by cao guangyao on 13-5-26.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MDescriptionController.h"
#import "NSString+Category.h"
@interface MDescriptionController ()
@property (retain,nonatomic) NSObject *description;
@end

@implementation MDescriptionController
@synthesize description=_description;

-(id) initWithDescription:(NSObject *)description
{
    self = [super init];
    if (self){
        self.description = description;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITextView *textView = [[[UITextView alloc] initWithFrame:self.view.bounds]autorelease];
    self.view = textView;
    
    if ([self.description isKindOfClass:[NSArray class]]) {
        //array description
        NSArray *stringArray = @[];
        
        for (NSString *value in (NSArray *)self.description) {
            
            stringArray = [stringArray arrayByAddingObject:[value stringByConvertingHTMLToPlainText]];
        }
        
        
        NSString *resultText = [stringArray componentsJoinedByString:@"\n"];
        
        textView.text = resultText ;
        
        
    }
    else if ([self.description isKindOfClass:[NSString class]])
    {
        //string description
        textView.text = [(NSString *)self.description stringByConvertingHTMLToPlainText];
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_description release];
    [super dealloc];
}

@end
