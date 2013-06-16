//
//  SLContainerViewController.m
//  DotGame
//
//  Created by Stuart Lynch on 15/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SLPassAndPlayViewController.h"
#import "SOChooseCodeViewController.h"
#import "SLPassAndPlayTransitionViewController.h"
#import "SOGameViewController.h"

@interface SLPassAndPlayViewController () <SOChooseCodeViewControllerDelegate, SOGameViewControllerDelegate, SLPassAndPlayTransitionViewControllerDelegate>
{
    UIViewController *_activeViewController;
    
    SOGameViewController *_playerOne;
    SOGameViewController *_playerTwo;
}
    
@end

@implementation SLPassAndPlayViewController

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
    SOChooseCodeViewController *player1ChooseCode = [[SOChooseCodeViewController alloc] initWithPlayType:SLPlayTypePassAndPlayPlayerOne];
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
    [viewController willMoveToParentViewController:nil];
    [self addChildViewController:viewController];
    
    [self transitionFromViewController:_activeViewController
                      toViewController:viewController
                              duration:0.4
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:nil
                            completion:^(BOOL finished) {
                                [_activeViewController removeFromParentViewController];
                                [viewController didMoveToParentViewController:self];
                                [_activeViewController didMoveToParentViewController:nil];
                                _activeViewController = viewController;
                               }];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SLPassAndPlayTransitionViewController
//////////////////////////////////////////////////////////////////////////

- (void)passAndPlayTransitionViewControllerReadyToTransition:(SLPassAndPlayTransitionViewController *)passAndPlay
{
    switch (passAndPlay.playType)
    {
        case SLPlayTypePassAndPlayPlayerOne:
        {
            [self transitionToViewController:_playerOne];
            break;
        }
        case SLPlayTypePassAndPlayPlayerTwo:
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
    
    SLPassAndPlayTransitionViewController *passAndPlayTransition = [[SLPassAndPlayTransitionViewController alloc] initWithPlayType:otherPlayer.playType];
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
        case SLPlayTypePassAndPlayPlayerOne:
        {
            SOChooseCodeViewController *player2ChooseCode = [[SOChooseCodeViewController alloc] initWithPlayType:SLPlayTypePassAndPlayPlayerTwo];
            player2ChooseCode.delegate = self;
            player2ChooseCode.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            _playerOne = [[SOGameViewController alloc] initWithPlayType:SLPlayTypePassAndPlayPlayerOne code:code];
            _playerOne.delegate = self;
            [self transitionToViewController:player2ChooseCode];
            break;
        }
        case SLPlayTypePassAndPlayPlayerTwo:
        {
            _playerTwo = [[SOGameViewController alloc] initWithPlayType:SLPlayTypePassAndPlayPlayerTwo code:code];
            _playerTwo.delegate = self;
            [self transitionToViewController:_playerOne];
            break;
        }
        default:
            break;
    }
}

@end
