//
//  SLPassAndPlayTransitionViewController.m
//  DotGame
//
//  Created by Stuart Lynch on 15/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOMessageViewController.h"

@interface SOMessageViewController ()

@end

@implementation SOMessageViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

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
    self.view.backgroundColor = GREY_COLOR_BTM_BACKGROUND;
    
	CGFloat offset = 0;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        offset = 22;
    }
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,206+offset)];
    backgroundView.backgroundColor = GREY_COLOR_TOP_BACKGROUND;
    
    _messageView = [[UITextView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width,100)];
    _messageView.font = [UIFont fontWithName:@"GothamHTF-Medium" size:24.0f];
    _messageView.textAlignment = NSTextAlignmentCenter;
    _messageView.userInteractionEnabled = NO;
    _messageView.backgroundColor = GREY_COLOR_TOP_BACKGROUND;
    _messageView.textColor = GREY_COLOR_TOP_TEXT;
    
    [self.view addSubview:backgroundView];
    [self.view addSubview:_messageView];
    
    [backgroundView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_messageView release];
    [super dealloc];
}

@end
