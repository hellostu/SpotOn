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
    SOChooseCodeViewController *player1ChooseCode = [[SOChooseCodeViewController alloc] initWithPlayType:SOPlayTypePassAndPlayPlayerOne difficulty:SODifficultyHard];
    player1ChooseCode.delegate = self;
    if ( (self = [super initWithViewController:player1ChooseCode]) != nil)
    {
        
    }
    [player1ChooseCode autorelease];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
#pragma mark SLPassAndPlayTransitionViewController
//////////////////////////////////////////////////////////////////////////

- (void)passAndPlayTransitionViewControllerReadyToTransition:(SOPassAndPlayTransitionViewController *)passAndPlay
{
    switch (passAndPlay.playType)
    {
        case SOPlayTypePassAndPlayPlayerOne:
        {
            [self transitionToViewController:_playerOne withTransitionAnimation:SOTransitionAnimationFlip];
            break;
        }
        case SOPlayTypePassAndPlayPlayerTwo:
        {
            [self transitionToViewController:_playerTwo withTransitionAnimation:SOTransitionAnimationFlip];
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
    [gameViewController.previousGuessesView updateFeedbackIndicatorsWithOpponentsCode:otherPlayer.code animated:YES];
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
    [self transitionToViewController:passAndPlayTransition withTransitionAnimation:SOTransitionAnimationFlip];
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
            SOChooseCodeViewController *player2ChooseCode = [[SOChooseCodeViewController alloc] initWithPlayType:SOPlayTypePassAndPlayPlayerTwo difficulty:SODifficultyHard];
            player2ChooseCode.delegate = self;
            player2ChooseCode.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            _playerOne = [[SOGameViewController alloc] initWithPlayType:SOPlayTypePassAndPlayPlayerOne difficulty:SODifficultyHard code:code];
            _playerOne.delegate = self;
            [self transitionToViewController:player2ChooseCode withTransitionAnimation:SOTransitionAnimationFlip];
            [player2ChooseCode release];
            break;
        }
        case SOPlayTypePassAndPlayPlayerTwo:
        {
            _playerTwo = [[SOGameViewController alloc] initWithPlayType:SOPlayTypePassAndPlayPlayerTwo difficulty:SODifficultyHard code:code];
            _playerTwo.delegate = self;
            [self transitionToViewController:_playerOne withTransitionAnimation:SOTransitionAnimationFlip];
            break;
        }
        default:
            break;
    }
}

@end
