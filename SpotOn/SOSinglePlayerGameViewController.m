//
//  SOSinglePlayerGameViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 25/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOSinglePlayerGameViewController.h"
#import "SOGameViewController.h"
#import "SOChooseFromThreeViewController.h"

@interface SOSinglePlayerGameViewController () <SOChooseFromThreeControllerDelegate, SOGameViewControllerDelegate>
{
    SOGameViewController *_game;
    NSArray *_code;
}

@end

@implementation SOSinglePlayerGameViewController

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
    SOChooseFromThreeViewController *chooseDifficulty = [[SOChooseFromThreeViewController alloc] initWithType:SOChooseFromThreeTypeDifficulty];
    chooseDifficulty.delegate = self;
    [self transitionToViewController:chooseDifficulty withTransitionAnimation:SOTransitionAnimationNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_game release];
    [_code release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOChooseDifficultyViewControllerDelegate
//////////////////////////////////////////////////////////////////////////

- (void)chooseFromThreeViewController:(SOChooseFromThreeViewController *)chooseDifficultyVC selectedDifficulty:(SODifficulty)difficulty
{
    _code = [self generateRandomCodeForDifficulty:difficulty];
    [_code retain];
    _game = [[SOGameViewController alloc] initWithPlayType:SOPlayTypeSinglePlayer difficulty:difficulty code:_code];
    _game.delegate = self;
    [self transitionToViewController:_game withTransitionAnimation:SOTransitionAnimationFlip];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOGameViewControllerDelegate
//////////////////////////////////////////////////////////////////////////

- (void)gameViewController:(SOGameViewController *)gameViewController didTakeTurnWithCode:(NSArray *)code
{
    [gameViewController.previousGuessesView updateFeedbackIndicatorsWithOpponentsCode:_code animated:YES completion:^(){
        [gameViewController.previousGuessesView addNewRowAnimated:YES];
        [gameViewController updateSubmitButton];
    }];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (NSArray *)generateRandomCodeForDifficulty:(SODifficulty)difficulty
{
    switch (difficulty)
    {
        case SODifficultyHard:
        {
            NSMutableArray *code = [[NSMutableArray alloc] initWithCapacity:5];
            for (int i=0; i<5; i++)
            {
                [code addObject:@(arc4random()%6)];
            }
            return [code autorelease];
            break;
        }
        case SODifficultyMedium:
        {
            NSMutableArray *code = [[NSMutableArray alloc] initWithCapacity:5];
            for (int i=0; i<4; i++)
            {
                [code addObject:@(arc4random()%6)];
            }
            return [code autorelease];
            break;
        }
        default:
        {
            NSMutableArray *code = [[NSMutableArray alloc] initWithCapacity:5];
            for (int i=0; i<4; i++)
            {
                [code addObject:@(arc4random()%4)];
            }
            return [code autorelease];
            break;
        }
    }
}

@end
