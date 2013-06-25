//
//  SOLoadingViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 24/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOLoadingViewController.h"

@interface SOLoadingViewController ()

@end

@implementation SOLoadingViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)init
{
    if ( (self = [super init]) != nil)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GREY_COLOR_BTM_BACKGROUND;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.delegate loadingViewControllerStartedLoading:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
