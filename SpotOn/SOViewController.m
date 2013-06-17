//
//  SOViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 16/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOViewController.h"

@interface SOViewController ()

@end

@implementation SOViewController

- (id)init
{
    if ( (self = [super init]) != nil)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat offset = 0;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        offset = 22;
    }
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,206+offset)];
    backgroundView.backgroundColor = GREY_COLOR_TOP_BACKGROUND;
    self.view.backgroundColor = GREY_COLOR_BTM_BACKGROUND;
    
    [self.view addSubview:backgroundView];
    [backgroundView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
