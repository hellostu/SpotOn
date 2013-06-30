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
#import "SOWaitingForCodeViewController.h"
#import "SOGuessFeedbackIndicator.h"
#import "SOGameResultViewController.h"
#import "SOChooseDifficultyViewController.h"
#import "SOLoadingViewController.h"

#import "GKTurnBasedMatch+otherParticipant.h"

@interface SOGameCenterViewController () <SOGamerCenterHelperDelegate, SOChooseCodeViewControllerDelegate, SOGameViewControllerDelegate, SOChooseDifficultyViewControllerDelegate, SOLoadingViewControllerDelegate, UIAlertViewDelegate>
{
    SOGameViewController    *_currentGame;
    
    NSArray                 *_opponentsGuessHistory;
    NSArray                 *_ownGuessHistory;
    
    NSArray                 *_opponentsCode;
    NSArray                 *_ownCode;
    
    GKTurnBasedMatchOutcome _outcome;
    
    SOGameType              _gameType;
    SODifficulty            _difficulty;
    
    UIImage                 *_ownImage;
    UIImage                 *_opponentsImage;
}

@end

@implementation SOGameCenterViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithGameType:(SOGameType)gameType
{
    if ( (self = [super init]) != nil)
    {
        SOGameCenterHelper *gameCenterHelper = [SOGameCenterHelper sharedInstance];
        gameCenterHelper.delegate = self;
        
        _opponentsCode = nil;
        _ownCode = nil;
        _opponentsGuessHistory = [@[] retain];
        _ownGuessHistory = [@[] retain];
        
        _gameType = gameType;
        _difficulty = SODifficultyUnassigned;
        
        [self loadPhotos];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SOGameCenterHelper sharedInstance].delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	SOGameCenterHelper *gameCenterHelper = [SOGameCenterHelper sharedInstance];
    gameCenterHelper.delegate = self;
    SOLoadingViewController *loadingViewController = [[SOLoadingViewController alloc] init];
    loadingViewController.delegate = self;
    [self transitionToViewController:loadingViewController withTransitionAnimation:SOTransitionAnimationNone];
}



- (void)gotoWinScreen
{
    SOGameResultViewController *resultVC = [[SOGameResultViewController alloc] initWithResult:SOGameResultWin
                                                                                      ownCode:_ownCode
                                                                                opponentsCode:_opponentsCode
                                                                                 ownBestGuess:nil
                                                                           opponentsBestGuess:nil];
    resultVC.ownProfilePicture.imageView.image = _ownImage;
    resultVC.opponentsProfilePicture.imageView.image = _opponentsImage;
    [self.navigationController pushViewController:resultVC animated:YES];
    [resultVC release];
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

- (void)loadingViewControllerStartedLoading:(SOLoadingViewController *)loadingViewController
{
    SOGameCenterHelper *gameCenterHelper = [SOGameCenterHelper sharedInstance];
    
    switch (_gameType)
    {
        case SOGameTypeExistingGame:
        {
            [self updateFromMatch:gameCenterHelper.currentMatch withCompletionHandler:^(NSError *error) {
                if (_difficulty == SODifficultyUnassigned)
                {
                    SOChooseDifficultyViewController *chooseDifficultyViewController = [[SOChooseDifficultyViewController alloc] init];
                    chooseDifficultyViewController.delegate = self;
                    [self transitionToViewController:chooseDifficultyViewController withTransitionAnimation:SOTransitionAnimationCrossFade];
                    [chooseDifficultyViewController release];
                }
                else if (_ownCode == nil)
                {
                    SOChooseCodeViewController *chooseCodeViewController = [[SOChooseCodeViewController alloc] initWithPlayType:SOPlayTypeGameCenter difficulty:_difficulty];
                    chooseCodeViewController.delegate = self;
                    [self transitionToViewController:chooseCodeViewController withTransitionAnimation:SOTransitionAnimationCrossFade];
                    [chooseCodeViewController release];
                }
                else if(_opponentsCode == nil && _ownCode != nil)
                {
                    SOWaitingForCodeViewController *waitingViewController = [[SOWaitingForCodeViewController alloc] init];
                    [self transitionToViewController:waitingViewController withTransitionAnimation:SOTransitionAnimationCrossFade];
                    [waitingViewController release];
                }
                else
                {
                    [_currentGame release];
                    _currentGame = nil;
                    _currentGame = [[SOGameViewController alloc] initWithPlayType:SOPlayTypeGameCenter difficulty:_difficulty code:_ownCode];
                    _currentGame.delegate = self;
                    [self transitionToViewController:_currentGame withTransitionAnimation:SOTransitionAnimationCrossFade];
                }
            }];
            break;
        }
        default:
        {
            SOChooseDifficultyViewController *chooseDifficultyViewController = [[SOChooseDifficultyViewController alloc] init];
            chooseDifficultyViewController.delegate = self;
            [self transitionToViewController:chooseDifficultyViewController withTransitionAnimation:SOTransitionAnimationCrossFade];
            [chooseDifficultyViewController release];
            break;
        }
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOGameCenterHelperDelegate
//////////////////////////////////////////////////////////////////////////

- (void)enterNewGame:(GKTurnBasedMatch *)match
{
    SOChooseCodeViewController *chooseCodeViewController = [[SOChooseCodeViewController alloc] initWithPlayType:SOPlayTypeGameCenter difficulty:_difficulty];
    chooseCodeViewController.delegate = self;
    [self transitionToViewController:chooseCodeViewController withTransitionAnimation:SOTransitionAnimationFlip];
    [chooseCodeViewController release];
    
}

- (void)layoutMatch:(GKTurnBasedMatch *)match
{
    [self updateFromMatch:match withCompletionHandler:^(NSError *error) {
        if (_opponentsCode == nil || _ownCode == nil)
        {
            SOChooseCodeViewController *chooseCodeViewController = [[SOChooseCodeViewController alloc] initWithPlayType:SOPlayTypeGameCenter difficulty:_difficulty];
            chooseCodeViewController.delegate = self;
            [self transitionToViewController:chooseCodeViewController withTransitionAnimation:SOTransitionAnimationFlip];
            [chooseCodeViewController release];
        }
        else if(self.activeViewController != _currentGame)
        {
            [_currentGame release];
            _currentGame = nil;
            _currentGame = [[SOGameViewController alloc] initWithPlayType:SOPlayTypeGameCenter difficulty:_difficulty code:_ownCode];
            _currentGame.delegate = self;
            [self updateFromMatch:match withCompletionHandler:^(NSError *error){
                [self transitionToViewController:_currentGame withTransitionAnimation:SOTransitionAnimationFlip];
            }];
            
        }
        if ([[SOGameCenterHelper sharedInstance] isMyTurn] == YES)
        {
            [_currentGame.previousGuessesView addNewRowAnimated:YES];
            [self displayOpponentsTurn];
        }
    }];
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

- (void)opponentQuit:(GKTurnBasedMatch *)match
{
    match.localParticipant.matchOutcome = GKTurnBasedMatchOutcomeWon;
    [match endMatchInTurnWithMatchData:match.matchData completionHandler:^(NSError *error) {
        NSLog(@"Opponent Quit");
    }];
    #warning TODO: handle opponent quit
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match
{
    if (match == [SOGameCenterHelper sharedInstance].currentMatch)
    {
        [self updateFromMatch:match withCompletionHandler:^(NSError *error){
            if ([[SOGameCenterHelper sharedInstance] isMyTurn] == YES)
            {
                [_currentGame.previousGuessesView addNewRowAnimated:YES];
            }
        }];
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOChooseDifficultyDelegate
//////////////////////////////////////////////////////////////////////////

- (void)chooseDifficultyViewController:(SOChooseDifficultyViewController *)chooseDifficultyVC selectedDifficulty:(SODifficulty)difficulty
{
    _difficulty = difficulty;
    
    SOChooseCodeViewController *chooseCodeViewController = [[SOChooseCodeViewController alloc] initWithPlayType:SOPlayTypeGameCenter difficulty:difficulty];
    chooseCodeViewController.delegate = self;
    [self transitionToViewController:chooseCodeViewController withTransitionAnimation:SOTransitionAnimationFlip];
    [chooseCodeViewController release];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOChooseCodeViewControllerDelegate
//////////////////////////////////////////////////////////////////////////

- (void)chooseCodeViewController:(SOChooseCodeViewController *)chooseCodeViewController didReturnCode:(NSArray *)code
{
    [self updateFromMatch:[SOGameCenterHelper sharedInstance].currentMatch withCompletionHandler:^(NSError *error) {
        _ownCode = [code retain];
        [self sendTurn:nil withCompletionHandler:^(NSError *error) {
            if (error)
            {
                NSLog(@"%@", error);
            }
        }];
        
        if (_opponentsCode == nil)
        {
            SOWaitingForCodeViewController *waitingForCode = [[SOWaitingForCodeViewController alloc] init];
            [self transitionToViewController:waitingForCode withTransitionAnimation:SOTransitionAnimationFlip];
            [waitingForCode release];
        }
        else
        {
            [_currentGame release];
            _currentGame = nil;
            _currentGame = [[SOGameViewController alloc] initWithPlayType:SOPlayTypeGameCenter difficulty:_difficulty code:_ownCode];
            _currentGame.delegate = self;
            [self transitionToViewController:_currentGame withTransitionAnimation:SOTransitionAnimationFlip];
        }
    }];
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
                                                                                 animated:NO
                                                                               completion:nil];
        
        NSArray *colorCode = [[SOGameCenterHelper sharedInstance] recoverColorsInRecepticles];
        if (colorCode != nil)
        {
            [gameViewController.codeSelectionView populateRecepticlesWithCode:colorCode];
            [gameViewController updateSubmitButton];
        }
        
        if ([[SOGameCenterHelper sharedInstance] isMyTurn] == YES)
        {
            [gameViewController.previousGuessesView addNewRowAnimated:YES];
        }
    }
}

- (void)gameViewController:(SOGameViewController *)gameViewController didTakeTurnWithCode:(NSArray *)code
{
    [self updateFromMatch:[SOGameCenterHelper sharedInstance].currentMatch withCompletionHandler:^(NSError *error) {
        [gameViewController.previousGuessesView updateFeedbackIndicatorsWithOpponentsCode:_opponentsCode
                                                                                 animated:YES
                                                                               completion:nil];
    }];
}

- (void)gameViewController:(SOGameViewController *)gameViewController requestedToSendTurnWithCode:(NSArray *)code
{
    [_currentGame startLoading];
    [self sendTurn:code withCompletionHandler:^(NSError *error) {
        if (error == nil)
        {
            [_currentGame submitTurn];
        }
        else
        {
            NSLog(@"Error: %@", error);
        }
        [_currentGame stopLoading];
    }];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIAlertViewDelegate
//////////////////////////////////////////////////////////////////////////

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (void)loadPhotos
{
    GKTurnBasedMatch *match = [SOGameCenterHelper sharedInstance].currentMatch;
    for (GKTurnBasedParticipant *participant in match.participants)
    {
        if ([participant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID])
        {
            [GKPlayer loadPlayersForIdentifiers:@[participant.playerID] withCompletionHandler:^(NSArray *players, NSError *error) {
                [players[0] loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo, NSError *error) {
                    if (photo != nil)
                    {
                        _ownImage = [photo retain];
                    }
                    else
                    {
                        _ownImage = [[UIImage imageNamed:@"gameover_avatar.png"] retain];
                    }
                }];
            }];
        }
        else if(participant.playerID != nil)
        {
            [GKPlayer loadPlayersForIdentifiers:@[participant.playerID] withCompletionHandler:^(NSArray *players, NSError *error) {
                [players[0] loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo, NSError *error) {
                    if (photo != nil)
                    {
                        _opponentsImage = [photo retain];
                    }
                    else
                    {
                        _opponentsImage = [[UIImage imageNamed:@"gameover_avatar.png"] retain];
                    }
                }];
            }];
        }
    }
    
    
    
    
}

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
        guessFeedbackIndicator.backgroundColor = GREY_COLOR_BTM_BACKGROUND;
        
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
        [_currentGame updateSubmitButton];
    }
}

- (void)updateFromMatch:(GKTurnBasedMatch *)match withCompletionHandler:(void(^)(NSError *error))completionHandler
{
    [match loadMatchDataWithCompletionHandler:^(NSData *matchData, NSError *error) {
        if (matchData != nil)
        {
            NSDictionary *gameDict = [NSJSONSerialization JSONObjectWithData:matchData options:0 error:0];
            
            if (gameDict[@"difficulty"] != nil)
            {
                _difficulty = ((NSNumber *)gameDict[@"difficulty"]).intValue;
            }
            
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
        if (completionHandler != nil)
        {
            completionHandler(error);
        }
    }];
    
}

- (NSDictionary *)gameStateWithMatch:(GKTurnBasedMatch *)match andCurrentTurn:(NSArray *)currentTurn
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
                if (currentTurn != nil)
                {
                    NSArray *guessHistoryWithCurrentTurn = [guessHistory arrayByAddingObject:currentTurn];
                    [ownState setValue:guessHistoryWithCurrentTurn forKey:@"guess_history"];
                }
                else
                {
                    [ownState setValue:guessHistory forKey:@"guess_history"];
                }
            }
            else
            {
                if (currentTurn != nil)
                {
                    [ownState setValue:@[currentTurn] forKey:@"guess_history"];
                }
                else
                {
                    [ownState setValue:@[] forKey:@"guess_history"];
                }
                
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
    
    [stateDict setValue:@(_difficulty) forKey:@"difficulty"];
    
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

- (void)sendTurn:(NSArray *)code withCompletionHandler:(void(^)(NSError *error))handler
{
    if (([self guessedOpponentsCode] == YES || [self opponentGuessedOurCode] == YES) &&
        _opponentsGuessHistory.count == _ownGuessHistory.count)
    {
        [self recieveEndGame:[SOGameCenterHelper sharedInstance].currentMatch];
    }
    else
    {
        [self takeTurnWithCode:code completion:handler];
    }
    
}

- (void)takeTurnWithCode:(NSArray *)code completion:(void(^)(NSError *error))handler
{
    GKTurnBasedMatch *currentMatch = [SOGameCenterHelper sharedInstance].currentMatch;
    NSDictionary *gameDict = [self gameStateWithMatch:currentMatch andCurrentTurn:code];

    NSData *data = [NSJSONSerialization dataWithJSONObject:gameDict options:0 error:nil];
    
    NSUInteger currentIndex = [currentMatch.participants
                               indexOfObject:currentMatch.currentParticipant];
    GKTurnBasedParticipant *nextParticipant;
    nextParticipant = [currentMatch.participants objectAtIndex:
                       ((currentIndex + 1) % [currentMatch.participants count ])];
    
    [currentMatch endTurnWithNextParticipants:@[nextParticipant]
                                  turnTimeout:0
                                    matchData:data completionHandler:handler];
}

- (void)endMatch
{
    GKTurnBasedMatch *currentMatch = [SOGameCenterHelper sharedInstance].currentMatch;
    NSDictionary *gameDict = [self gameStateWithMatch:currentMatch andCurrentTurn:nil];
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
