//
//  SLContainerViewController.m
//  DotGame
//
//  Created by Stuart Lynch on 15/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOPassAndPlayViewController.h"
#import "SOChooseCodeViewController.h"
#import "SOPassAndPlayTransitionViewController.h"
#import "SOGameViewController.h"
#import "SOGameCenterHelper.h"

@interface SOPassAndPlayViewController () <SOChooseCodeViewControllerDelegate, SOGameViewControllerDelegate, SOPassAndPlayTransitionViewControllerDelegate>
{
    UIViewController *_activeViewController;
    
    SOGameViewController *_playerOne;
    SOGameViewController *_playerTwo;
}
    
@end

@implementation SOPassAndPlayViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)init
{
    if ( (self = [super init]) != nil)
    {
        //SOGameCenterHelper *gameCenterHelper = [SOGameCenterHelper sharedInstance];
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
    SOChooseCodeViewController *player1ChooseCode = [[SOChooseCodeViewController alloc] initWithPlayType:SOPlayTypePassAndPlayPlayerOne];
    player1ChooseCode.delegate = self;
    player1ChooseCode.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _activeViewController = player1ChooseCode;
    
    [self addChildViewController:player1ChooseCode];
    [self.view addSubview:player1ChooseCode.view];
    
    [player1ChooseCode release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_playerOne release];
    [_playerTwo release];
    [super dealloc];
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

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SLPassAndPlayTransitionViewController
//////////////////////////////////////////////////////////////////////////

- (void)passAndPlayTransitionViewControllerReadyToTransition:(SOPassAndPlayTransitionViewController *)passAndPlay
{
    switch (passAndPlay.playType)
    {
        case SOPlayTypePassAndPlayPlayerOne:
        {
            [self transitionToViewController:_playerOne];
            break;
        }
        case SOPlayTypePassAndPlayPlayerTwo:
        {
            [self transitionToViewController:_playerTwo];
            break;
        }
        default:
            break;
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SLGameViewControllerDelegate
//////////////////////////////////////////////////////////////////////////

- (void)gameViewController:(SOGameViewController *)gameViewController didTakeTurnWithCode:(NSArray *)code
{
    SOGameViewController *otherPlayer = _playerOne;
    if (gameViewController == otherPlayer)
    {
        otherPlayer = _playerTwo;
    }
    NSDictionary *feedback = [otherPlayer provideFeedbackForCode:code];
    int rightColorWrongPosition = ((NSNumber *)feedback[@"Right Color Wrong Position"]).intValue;
    int rightColorRightPosition = ((NSNumber *)feedback[@"Right Color Right Position"]).intValue;
    [gameViewController setFeedbackWithRightColorsRightPosition:rightColorRightPosition
                                       rightColorsWrongPosition:rightColorWrongPosition];
}

- (void)gameViewControllerReadyToTransition:(SOGameViewController *)gameViewController
{
    SOGameViewController *otherPlayer = _playerOne;
    if (gameViewController == otherPlayer)
    {
        otherPlayer = _playerTwo;
    }
    
    SOPassAndPlayTransitionViewController *passAndPlayTransition = [[SOPassAndPlayTransitionViewController alloc] initWithPlayType:otherPlayer.playType];
    passAndPlayTransition.delegate = self;
    [self transitionToViewController:passAndPlayTransition];
    [passAndPlayTransition release];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SLChooseCodeViewControllerDelegate
//////////////////////////////////////////////////////////////////////////

- (void)chooseCodeViewController:(SOChooseCodeViewController *)chooseCodeViewController didReturnCode:(NSArray *)code
{
    switch (chooseCodeViewController.playerType)
    {
        case SOPlayTypePassAndPlayPlayerOne:
        {
            SOChooseCodeViewController *player2ChooseCode = [[SOChooseCodeViewController alloc] initWithPlayType:SOPlayTypePassAndPlayPlayerTwo];
            player2ChooseCode.delegate = self;
            player2ChooseCode.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            _playerOne = [[SOGameViewController alloc] initWithPlayType:SOPlayTypePassAndPlayPlayerOne code:code];
            _playerOne.delegate = self;
            [self transitionToViewController:player2ChooseCode];
            [player2ChooseCode release];
            break;
        }
        case SOPlayTypePassAndPlayPlayerTwo:
        {
            _playerTwo = [[SOGameViewController alloc] initWithPlayType:SOPlayTypePassAndPlayPlayerTwo code:code];
            _playerTwo.delegate = self;
            [self transitionToViewController:_playerOne];
            break;
        }
        default:
            break;
    }
}

@end
