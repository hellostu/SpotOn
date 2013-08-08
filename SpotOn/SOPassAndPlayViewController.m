//
//  SLContainerViewController.m
//  DotGame
//
//  Created by Stuart Lynch on 15/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOPassAndPlayViewController.h"
#import "SOChooseCodeViewController.h"
#import "SOChooseFromThreeViewController.h"
#import "SOPassAndPlayTransitionViewController.h"
#import "SOGameViewController.h"
#import "SOGameCenterHelper.h"
#import "SOPassAndPlayStepsViewController.h"

@interface SOPassAndPlayViewController () <SOGameViewControllerDelegate, SOPassAndPlayTransitionViewControllerDelegate, SOChooseFromThreeControllerDelegate, SOPassAndPlayStepsViewControllerDelegate>
{
    SOGameViewController    *_playerOne;
    SOGameViewController    *_playerTwo;
    
    SODifficulty            _difficulty;
}
    
@end

@implementation SOPassAndPlayViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)init
{
    SOChooseFromThreeViewController *chooseDifficulty = [[SOChooseFromThreeViewController alloc] initWithType:SOChooseFromThreeTypeDifficulty];
    chooseDifficulty.delegate = self;
    if ( (self = [super initWithViewController:chooseDifficulty]) != nil)
    {
        
    }
    [chooseDifficulty release];
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
#pragma mark SOPassAndPlayStepsViewControllerDelegate
//////////////////////////////////////////////////////////////////////////

- (void)passAndPlayStepsViewController:(SOPassAndPlayStepsViewController *)passAndPlayViewController returnedWithStep:(int)step
{
    switch (step)
    {
        case 1:
        {
            SOPassAndPlayStepsViewController *stepTwo = [[SOPassAndPlayStepsViewController alloc] initWithStep:2 name:passAndPlayViewController.name difficulty:_difficulty];
            stepTwo.delegate = self;
            stepTwo.playType = passAndPlayViewController.playType;
            [self.navigationController pushViewController:stepTwo animated:YES];
            [stepTwo release];
            break;
        }
        case 2:
        {
            SOPassAndPlayStepsViewController *stepThree = [[SOPassAndPlayStepsViewController alloc] initWithStep:3 name:passAndPlayViewController.name difficulty:_difficulty];
            stepThree.delegate = self;
            stepThree.playType = passAndPlayViewController.playType;
            [self.navigationController pushViewController:stepThree animated:YES];
            [stepThree release];
            break;
        }
    }
}

- (void)passAndPlayStepsViewController:(SOPassAndPlayStepsViewController *)passAndPlayerViewController returnedWithCode:(NSArray *)code
{
    switch (passAndPlayerViewController.playType)
    {
        case SOPlayTypePassAndPlayPlayerOne:
        {
            SOPassAndPlayStepsViewController *stepOne = [[SOPassAndPlayStepsViewController alloc] initWithStep:1 name:nil difficulty:_difficulty];
            stepOne.delegate = self;
            stepOne.playType = SOPlayTypePassAndPlayPlayerTwo;
            _playerOne = [[SOGameViewController alloc] initWithPlayType:SOPlayTypePassAndPlayPlayerOne difficulty:_difficulty code:code];
            _playerOne.delegate = self;
            [self.navigationController pushViewController:stepOne animated:YES];
            [stepOne release];
            break;
        }
        case SOPlayTypePassAndPlayPlayerTwo:
        {
            _playerTwo = [[SOGameViewController alloc] initWithPlayType:SOPlayTypePassAndPlayPlayerTwo difficulty:_difficulty code:code];
            _playerTwo.delegate = self;
            [self.navigationController popToViewController:self animated:NO];
            [self transitionToViewController:_playerOne withTransitionAnimation:SOTransitionAnimationFlip];
            break;
        }
        default:
            break;
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOChooseFromThreeViewControllerDelegate
//////////////////////////////////////////////////////////////////////////

- (void)chooseFromThreeViewController:(SOChooseFromThreeViewController *)chooseFromThreeVC selectedDifficulty:(SODifficulty)difficulty
{
    _difficulty = difficulty;
    SOPassAndPlayStepsViewController *stepOne = [[SOPassAndPlayStepsViewController alloc] initWithStep:1 name:nil difficulty:difficulty];
    stepOne.delegate = self;
    stepOne.playType = SOPlayTypePassAndPlayPlayerOne;
    [self.navigationController pushViewController:stepOne animated:YES];
    [stepOne release];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOPassAndPlayTransitionViewControllerDelegate
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
#pragma mark SOGameViewControllerDelegate
//////////////////////////////////////////////////////////////////////////

- (void)gameViewController:(SOGameViewController *)gameViewController didTakeTurnWithCode:(NSArray *)code
{
    SOGameViewController *otherPlayer = _playerOne;
    if (gameViewController == otherPlayer)
    {
        otherPlayer = _playerTwo;
    }
    [gameViewController.previousGuessesView updateFeedbackIndicatorsWithOpponentsCode:otherPlayer.code animated:YES completion:nil];
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

@end
