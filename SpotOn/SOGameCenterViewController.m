//
//  SOGameCenterViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 18/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOGameCenterViewController.h"
#import "SOGameCenterHelper.h"
#import "SOGameViewController.h"
#import "SOChooseCodeViewController.h"
#import "SOMenuViewController.h"
#import "SOWaitingForCodeViewController.h"

@interface SOGameCenterViewController () <SOGamerCenterHelperDelegate, SOChooseCodeViewControllerDelegate, SOGameViewControllerDelegate>
{
    SOGameViewController    *_currentGame;
    
    NSArray                 *_opponentsGuessHistory;
    NSArray                 *_ownGuessHistory;
    
    NSArray                 *_opponentsCode;
    NSArray                 *_ownCode;
}

@end

@implementation SOGameCenterViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)init
{
    SOMenuViewController *menu = [[SOMenuViewController alloc] init];
    
    if ( (self = [super initWithViewController:menu]) != nil)
    {
        _opponentsCode = nil;
        _ownCode = nil;
        _opponentsGuessHistory = nil;
        
        _currentGame = [[SOGameViewController alloc] initWithPlayType:SOPlayTypeGameCenter code:_ownCode];
        _currentGame.delegate = self;
        
        SOGameCenterHelper *gameCenterHelper = [SOGameCenterHelper sharedInstance];
        gameCenterHelper.delegate = self;
    }
    [menu autorelease];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[SOGameCenterHelper sharedInstance].delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_currentGame release];
    [_opponentsGuessHistory release];
    [_opponentsCode release];
    [_ownCode release];
    [_ownGuessHistory release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOGameCenterHelperDelegate
//////////////////////////////////////////////////////////////////////////

- (void)enterNewGame:(GKTurnBasedMatch *)match
{
    SOChooseCodeViewController *chooseCodeViewController = [[SOChooseCodeViewController alloc] initWithPlayType:SOPlayTypeGameCenter];
    chooseCodeViewController.delegate = self;
    [self transitionToViewController:chooseCodeViewController];
    [chooseCodeViewController release];
    
}

- (void)layoutMatch:(GKTurnBasedMatch *)match
{
    [self updateFromMatch:match];
    if (_opponentsCode == nil || _ownCode == nil)
    {
        SOChooseCodeViewController *chooseCodeViewController = [[SOChooseCodeViewController alloc] initWithPlayType:SOPlayTypeGameCenter];
        chooseCodeViewController.delegate = self;
        [self transitionToViewController:chooseCodeViewController];
        [chooseCodeViewController release];
    }
    else
    {
        [self transitionToViewController:_currentGame];
    }
}

- (void)enterExistingGame:(GKTurnBasedMatch *)match
{
    [self updateFromMatch:match];
    if (_opponentsCode == nil || _ownCode == nil)
    {
        SOChooseCodeViewController *chooseCodeViewController = [[SOChooseCodeViewController alloc] initWithPlayType:SOPlayTypeGameCenter];
        chooseCodeViewController.delegate = self;
        [self transitionToViewController:chooseCodeViewController];
        [chooseCodeViewController release];
    }
    else
    {
        [self transitionToViewController:_currentGame];
    }
}

- (void)recieveEndGame:(GKTurnBasedMatch *)match
{
    
}

-(void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:
                       @"Another game needs your attention!" message:notice
                                                delegate:self cancelButtonTitle:@"Sweet!"
                                       otherButtonTitles:nil];
    [av show];
    [av release];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOChooseCodeViewControllerDelegate
//////////////////////////////////////////////////////////////////////////

- (void)chooseCodeViewController:(SOChooseCodeViewController *)chooseCodeViewController didReturnCode:(NSArray *)code
{
    _ownCode = [code retain];
    [self sendTurn];
    
    if (_opponentsCode == nil)
    {
        SOWaitingForCodeViewController *waitingForCode = [[SOWaitingForCodeViewController alloc] init];
        [self transitionToViewController:waitingForCode];
        [waitingForCode release];
    }
    else
    {
        [self transitionToViewController:_currentGame];
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOGameViewControllerDelegate
//////////////////////////////////////////////////////////////////////////

- (void)gameViewControllerDidLoadViews:(SOGameViewController *)gameViewController
{
    if (_ownGuessHistory != nil)
    {
        [gameViewController.previousGuessesView updateWithGuesses:_ownGuessHistory];
        [gameViewController.previousGuessesView updateFeedbackIndicatorsWithOpponentsCode:_opponentsCode
                                                                                 animated:NO];
    }
}

- (void)gameViewController:(SOGameViewController *)gameViewController didTakeTurnWithCode:(NSArray *)code
{
    [gameViewController.previousGuessesView updateFeedbackIndicatorsWithOpponentsCode:_opponentsCode
                                                                             animated:YES];
    [self sendTurn];
}

- (void)gameViewControllerReadyToTransition:(SOGameViewController *)gameViewController
{
    
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (void)updateFromMatch:(GKTurnBasedMatch *)match
{
    NSData *matchData = match.matchData;
    NSDictionary *gameDict = [NSJSONSerialization JSONObjectWithData:matchData options:0 error:0];
    
    NSString *ourID = [GKLocalPlayer localPlayer].playerID;
    NSString *theirID = [self opponentIDFromMatch:match];
    
    NSDictionary *ownState = gameDict[ourID];
    NSDictionary *opponentState = gameDict[theirID];
    
    NSArray *ownCode = ownState[@"code"];
    if (ownCode != nil)
    {
        [_ownCode release];
        _ownCode = [ownCode retain];
    }
    
    NSArray *ownGuessHistory = ownState[@"guess_history"];
    if (ownGuessHistory != nil)
    {
        [_ownGuessHistory release];
        _ownGuessHistory = [ownGuessHistory retain];
    }
    
    NSArray *opponentCode = opponentState[@"code"];
    if (opponentState != nil)
    {
        [_opponentsCode release];
        _opponentsCode = [opponentCode retain];
    }
    
    NSArray *opponentGuessHistory = opponentState[@"guess_history"];
    if (opponentGuessHistory != nil)
    {
        [_opponentsGuessHistory release];
        _opponentsGuessHistory = [opponentGuessHistory retain];
    }
    
    
}

- (NSDictionary *)gameStateWithMatch:(GKTurnBasedMatch *)match
{
    NSString *ourID = [GKLocalPlayer localPlayer].playerID;
    NSString *theirID = [self opponentIDFromMatch:match];

    NSMutableDictionary *ownState = [[NSMutableDictionary alloc] initWithCapacity:2];
    if (_ownCode != nil)
    {
        [ownState setValue:_ownCode forKey:@"code"];
        if (_currentGame != nil)
        {
            NSArray *guessHistory = [_currentGame guessHistory];
            if (guessHistory != nil)
            {
                [ownState setValue:guessHistory forKey:@"guess_history"];
            }
        }
    }
    
    NSMutableDictionary *opponentsState = [[NSMutableDictionary alloc] initWithCapacity:2];
    if (_opponentsCode != nil)
    {
        [opponentsState setValue:_opponentsCode forKey:@"code"];
        if (_opponentsGuessHistory != nil)
        {
            [opponentsState setValue:_opponentsGuessHistory forKey:@"guess_history"];
        }
    }
    
    NSMutableDictionary *stateDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    if (ourID != nil)
    {
        [stateDict setValue:ownState forKey:ourID];
    }
    if (theirID != nil)
    {
        [stateDict setValue:opponentsState forKey:theirID];
    }
    
    [ownState release];
    [opponentsState release];
    
    return [stateDict autorelease];
}

- (NSString *)opponentIDFromMatch:(GKTurnBasedMatch *)match
{
    NSString *ourID = [GKLocalPlayer localPlayer].playerID;
    for (GKTurnBasedParticipant *participant in match.participants)
    {
        if ([participant.playerID isEqualToString:ourID] == NO)
        {
            return participant.playerID;
        }
    }
    return nil;
}

- (void)sendTurn
{
    GKTurnBasedMatch *currentMatch = [SOGameCenterHelper sharedInstance].currentMatch;
    NSDictionary *gameDict = [self gameStateWithMatch:currentMatch];
    NSData *data = [NSJSONSerialization dataWithJSONObject:gameDict options:0 error:nil];
    
    
    NSUInteger currentIndex = [currentMatch.participants
                               indexOfObject:currentMatch.currentParticipant];
    GKTurnBasedParticipant *nextParticipant;
    nextParticipant = [currentMatch.participants objectAtIndex:
                       ((currentIndex + 1) % [currentMatch.participants count ])];
    
    [currentMatch endTurnWithNextParticipants:@[nextParticipant]
                                  turnTimeout:0
                                    matchData:data completionHandler:^(NSError *error) {
                                        if (error)
                                        {
                                            NSLog(@"%@", error);
                                        }
                                    }];
}

@end
