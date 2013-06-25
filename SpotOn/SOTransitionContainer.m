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

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithViewController:(UIViewController *)viewController
{
    if ((self = [super init]) != nil)
    {
        [self addChildViewController:viewController];
        _activeViewController = [viewController retain];
    }
    return self;
}

- (id)init
{
    if ((self = [super init]) != nil)
    {
        UIViewController *placeHolder = [[UIViewController alloc] init];
        [self addChildViewController:placeHolder];
        _activeViewController = placeHolder;
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
    if (_activeViewController != nil)
    {
        [self.view addSubview:_activeViewController.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_activeViewController release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (void)transitionToViewController:(UIViewController *)viewController withTransitionAnimation:(SOTransitionAnimation) transitionAnimation
{
    [_activeViewController willMoveToParentViewController:nil];
    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    
    switch (transitionAnimation)
    {
        case SOTransitionAnimationSlideInFromLeft:
        {
            CGRect frame = _activeViewController.view.frame;
            frame.origin.x -= frame.size.width;
            viewController.view.frame = frame;
            [self transitionFromViewController:_activeViewController
                              toViewController:viewController
                                      duration:0.4
                                       options:UIViewAnimationOptionCurveLinear
                                    animations:^{
                                        CGRect frame = _activeViewController.view.frame;
                                        viewController.view.frame = _activeViewController.view.frame;
                                        frame.origin.x += frame.size.width;
                                        _activeViewController.view.frame = frame;
                                    }
                                    completion:^(BOOL finished) {
                                        [_activeViewController didMoveToParentViewController:nil];
                                        [viewController didMoveToParentViewController:self];
                                        [_activeViewController.view removeFromSuperview];
                                        [_activeViewController removeFromParentViewController];
                                        [_activeViewController release];
                                        _activeViewController = [viewController retain];
                                    }];
            break;
        }
        case SOTransitionAnimationSlideInFromRight:
        {
            CGRect frame = _activeViewController.view.frame;
            frame.origin.x += frame.size.width;
            viewController.view.frame = frame;
            [self transitionFromViewController:_activeViewController
                              toViewController:viewController
                                      duration:0.4
                                       options:UIViewAnimationOptionCurveLinear
                                    animations:^{
                                        CGRect frame = _activeViewController.view.frame;
                                        viewController.view.frame = _activeViewController.view.frame;
                                        frame.origin.x -= frame.size.width;
                                        _activeViewController.view.frame = frame;
                                    }
                                    completion:^(BOOL finished) {
                                        [_activeViewController didMoveToParentViewController:nil];
                                        [viewController didMoveToParentViewController:self];
                                        [_activeViewController.view removeFromSuperview];
                                        [_activeViewController removeFromParentViewController];
                                        [_activeViewController release];
                                        _activeViewController = [viewController retain];
                                    }];
            break;
        }
        case SOTransitionAnimationFlip:
        {
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
                                        [_activeViewController release];
                                        _activeViewController = [viewController retain];
                                    }];
            break;
        }
        case SOTransitionAnimationCrossFade:
        {
            [self transitionFromViewController:_activeViewController
                              toViewController:viewController
                                      duration:0.4
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:nil
                                    completion:^(BOOL finished) {
                                        [_activeViewController didMoveToParentViewController:nil];
                                        [viewController didMoveToParentViewController:self];
                                        [_activeViewController.view removeFromSuperview];
                                        [_activeViewController removeFromParentViewController];
                                        [_activeViewController release];
                                        _activeViewController = [viewController retain];
                                    }];
            break;
        }
        default:
        {
            [self transitionFromViewController:_activeViewController
                              toViewController:viewController
                                      duration:0.0
                                       options:0
                                    animations:nil
                                    completion:^(BOOL finished) {
                                        [_activeViewController didMoveToParentViewController:nil];
                                        [viewController didMoveToParentViewController:self];
                                        [_activeViewController.view removeFromSuperview];
                                        [_activeViewController removeFromParentViewController];
                                        [_activeViewController release];
                                        _activeViewController = [viewController retain];
                                    }];
            break;
        }
    }
}

@end
