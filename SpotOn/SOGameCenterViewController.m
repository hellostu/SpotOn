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
#import "SOGuessFeedbackIndicator.h"

@interface SOGameCenterViewController () <SOGamerCenterHelperDelegate, SOChooseCodeViewControllerDelegate, SOGameViewControllerDelegate, UIAlertViewDelegate>
{
    SOGameViewController    *_currentGame;
    
    NSArray                 *_opponentsGuessHistory;
    NSArray                 *_ownGuessHistory;
    
    NSArray                 *_opponentsCode;
    NSArray                 *_ownCode;
    
    GKTurnBasedMatchOutcome _outcome;
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
        _opponentsGuessHistory = [@[] retain];
        _ownGuessHistory = [@[] retain];
        
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
    else if(self.activeViewController != _currentGame)
    {
        [_currentGame release];
        _currentGame = nil;
        _currentGame = [[SOGameViewController alloc] initWithPlayType:SOPlayTypeGameCenter code:_ownCode];
        _currentGame.delegate = self;
        [self updateFromMatch:match];
        [self transitionToViewController:_currentGame];
    }
    if ([[SOGameCenterHelper sharedInstance] isMyTurn] == YES)
    {
        [_currentGame.previousGuessesView addNewRowAnimated:YES];
        [self displayOpponentsTurn];
    }
}

- (void)enterExistingGame:(GKTurnBasedMatch *)match
{
    [self layoutMatch:match];
}

- (void)recieveEndGame:(GKTurnBasedMatch *)match
{
    [self endMatch];
    
    NSString *title = @"";
    NSString *message = @"";
    if (_outcome == GKTurnBasedMatchOutcomeWon)
    {
        title = @"Congratulations!";
        message = @"You Won!";
    }
    else if(_outcome == GKTurnBasedMatchOutcomeLost)
    {
        title = @"Aww Shucks!";
        message = @"You Lost!";
    }
    else
    {
        title = @"Nice going!";
        message = @"You tied with your opponent.";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

-(void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match
{
    if (match == [SOGameCenterHelper sharedInstance].currentMatch)
    {
        [self updateFromMatch:match];
        if ([[SOGameCenterHelper sharedInstance] isMyTurn] == YES)
        {
            [_currentGame.previousGuessesView addNewRowAnimated:YES];
        }
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOChooseCodeViewControllerDelegate
//////////////////////////////////////////////////////////////////////////

- (void)chooseCodeViewController:(SOChooseCodeViewController *)chooseCodeViewController didReturnCode:(NSArray *)code
{
    [self updateFromMatch:[SOGameCenterHelper sharedInstance].currentMatch];
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
        [_currentGame release];
        _currentGame = nil;
        _currentGame = [[SOGameViewController alloc] initWithPlayType:SOPlayTypeGameCenter code:_ownCode];
        _currentGame.delegate = self;
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
        if ([[SOGameCenterHelper sharedInstance] isMyTurn] == YES)
        {
            [gameViewController.previousGuessesView addNewRowAnimated:YES];
        }
    }
}

- (void)gameViewController:(SOGameViewController *)gameViewController didTakeTurnWithCode:(NSArray *)code
{
    [gameViewController.previousGuessesView updateFeedbackIndicatorsWithOpponentsCode:_opponentsCode
                                                                             animated:YES];
    [self updateFromMatch:[SOGameCenterHelper sharedInstance].currentMatch];
    [self sendTurn];
}

- (void)gameViewControllerReadyToTransition:(SOGameViewController *)gameViewController
{
    
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIAlertViewDelegate
//////////////////////////////////////////////////////////////////////////

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    SOMenuViewController *menu = [[SOMenuViewController alloc] init];
    [self transitionToViewController:menu];
    [menu release];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (BOOL)guessedOpponentsCode
{
    if (_ownGuessHistory.count > 0)
    {
        
        NSDictionary *feedback = [_currentGame.previousGuessesView provideFeedbackForGuess:[_ownGuessHistory lastObject] withOpponentsCode:_opponentsCode];
        
        int rightColorRightPosition = ((NSNumber *)feedback[@"Right Color Right Position"]).intValue;
        if (rightColorRightPosition==_ownCode.count)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

- (BOOL)opponentGuessedOurCode
{
    if (_ownGuessHistory.count > 0)
    {
        NSDictionary *feedback = [_currentGame.previousGuessesView provideFeedbackForGuess:[_opponentsGuessHistory lastObject] withOpponentsCode:_ownCode];
        
        int rightColorRightPosition = ((NSNumber *)feedback[@"Right Color Right Position"]).intValue;
        if (rightColorRightPosition==_ownCode.count)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

- (void)displayOpponentsTurn
{
    if (_opponentsGuessHistory != nil && self.activeViewController == _currentGame)
    {
        NSArray *guess = [_opponentsGuessHistory lastObject];
        
        NSDictionary *feedback = [_currentGame.previousGuessesView provideFeedbackForGuess:guess withOpponentsCode:_ownCode];
        SOGuessFeedbackIndicator *guessFeedbackIndicator = [[SOGuessFeedbackIndicator alloc] initWithNumberRecepticles:guess.count];
        
        int rightColorWrongPosition = ((NSNumber *)feedback[@"Right Color Wrong Position"]).intValue;
        int rightColorRightPosition = ((NSNumber *)feedback[@"Right Color Right Position"]).intValue;
        
        [guessFeedbackIndicator setRightColorRightPosition:rightColorRightPosition
                                andRightColorWrongPosition:rightColorWrongPosition];
        
        guessFeedbackIndicator.frame = CGRectMake(0, 0, 50, 50);
        
        NSString *message = @"";
        NSString *title = @"";
        
        if (rightColorRightPosition == _ownCode.count)
        {
            if (_opponentsGuessHistory.count == _ownGuessHistory.count)
            {
                title = @"Oh bloody 'ell!";
                message = @"Alas you just lost.\n\n\n\n";
            }
            else
            {
                title = @"Your Code is Cracked!";
                message = @"Take one more go to try and draw!u\n\n\n\n";
            }
        }
        else
        {
            title = @"It's your turn!";
            message = @"This is how your opponent did:\n\n\n\n";
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        guessFeedbackIndicator.center = CGPointMake(145, 100);
        
        [alertView addSubview:guessFeedbackIndicator];
        [guessFeedbackIndicator release];
        [alertView show];
        [guessFeedbackIndicator release];
        
        [_currentGame updateSubmitButton];
    }
}

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
    
    NSArray *ownGuessHistory = [_currentGame.previousGuessesView guessesList];
    if (ownGuessHistory.count == 0)
    {
        ownGuessHistory = ownState[@"guess_history"];
        if (ownGuessHistory !=nil)
        {
            [_ownGuessHistory release];
            _ownGuessHistory = [ownGuessHistory retain];
        }
    }
    else
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
    if (([self guessedOpponentsCode] == YES || [self opponentGuessedOurCode] == YES) &&
        _opponentsGuessHistory.count == _ownGuessHistory.count)
    {
        [self recieveEndGame:[SOGameCenterHelper sharedInstance].currentMatch];
    }
    else
    {
        [self takeTurn];
    }
    
}

- (void)takeTurn
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

- (void)endMatch
{
    GKTurnBasedMatch *currentMatch = [SOGameCenterHelper sharedInstance].currentMatch;
    NSDictionary *gameDict = [self gameStateWithMatch:currentMatch];
    NSData *data = [NSJSONSerialization dataWithJSONObject:gameDict options:0 error:nil];
    
    if ([self guessedOpponentsCode] == YES && [self opponentGuessedOurCode] == YES)
    {
        for (GKTurnBasedParticipant *part in currentMatch.participants)
        {
            part.matchOutcome = GKTurnBasedMatchOutcomeTied;
        }
        _outcome = GKTurnBasedMatchOutcomeTied;
    }
    else if([self guessedOpponentsCode] == YES)
    {
        for (GKTurnBasedParticipant *part in currentMatch.participants)
        {
            if ([part.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID] == YES)
            {
                part.matchOutcome = GKTurnBasedMatchOutcomeWon;
                _outcome = GKTurnBasedMatchOutcomeWon;
            }
            else
            {
                part.matchOutcome = GKTurnBasedMatchOutcomeLost;
            }
            
        }
    }
    else if([self opponentGuessedOurCode] == YES)
    {
        for (GKTurnBasedParticipant *part in currentMatch.participants)
        {
            if ([part.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID] == YES)
            {
                part.matchOutcome = GKTurnBasedMatchOutcomeLost;
                _outcome = GKTurnBasedMatchOutcomeLost;
            }
            else
            {
                part.matchOutcome = GKTurnBasedMatchOutcomeWon;
            }
            
        }
    }
    [currentMatch endMatchInTurnWithMatchData:data
                            completionHandler:^(NSError *error) {
                                if (error) {
                                    NSLog(@"%@", error);
                                }
                            }];
}

@end
