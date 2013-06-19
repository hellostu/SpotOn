//
//  SOTransitionContainer.m
//  SpotOn
//
//  Created by Stuart Lynch on 18/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOTransitionContainer.h"

@interface SOTransitionContainer ()

@end

@implementation SOTransitionContainer

- (id)initWithViewController:(UIViewController *)viewController
{
    if ((self = [super init]) != nil)
    {
        [self addChildViewController:viewController];
        _activeViewController = viewController;
    }
    return self;
}

- (void)loadView
{
    self.wantsFullScreenLayout = YES;
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    frame.size.height-=20;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.view = view;
    [view release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view addSubview:_activeViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (void)transitionToViewController:(UIViewController *)viewController
{
    [_activeViewController willMoveToParentViewController:nil];
    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    
    [self transitionFromViewController:_activeViewController
                      toViewController:viewController
                              duration:0.4
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:nil
                            completion:^(BOOL finished) {
                                [_activeViewController didMoveToParentViewController:nil];
                                [viewController didMoveToParentViewController:self];
                                [_activeViewController.view removeFromSuperview];
                                [_activeViewController removeFromParentViewController];
                                _activeViewController = viewController;
                            }];
}

@end
