//
//  SOGameCenterHelper.m
//  SpotOn
//
//  Created by Stuart Lynch on 18/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOGameCenterHelper.h"

@interface SOGameCenterHelper ()
{
    BOOL                _matchStarted;
    UIViewController    *_presentingViewController;
}

@end

@implementation SOGameCenterHelper

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

static SOGameCenterHelper *gameCenterHelper = nil;

+ (SOGameCenterHelper *)sharedInstance
{
    if (gameCenterHelper == nil)
    {
        gameCenterHelper = [[SOGameCenterHelper alloc] init];
    }
    return gameCenterHelper;
}

- (id)init
{
    if ( (self = [super init]) != nil)
    {
        _matchStarted = NO;
        _gameCenterAvailable = [self isGameCenterAvailable];
        if (self.gameCenterAvailable == YES)
        {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties
//////////////////////////////////////////////////////////////////////////

- (BOOL)isGameCenterAvailable
{
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Notifications
//////////////////////////////////////////////////////////////////////////

- (void)authenticationChanged
{
    if ([GKLocalPlayer localPlayer].isAuthenticated && self.userAuthenticated == NO)
    {
        NSLog(@"Authentication changed: player authenticated.");
        _userAuthenticated = TRUE;
    }
    else if ([GKLocalPlayer localPlayer].isAuthenticated == NO && self.userAuthenticated)
    {
        NSLog(@"Authentication changed: player not authenticated");
        _userAuthenticated = FALSE;
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark GKTurnBasedEventHandlerDelegate
//////////////////////////////////////////////////////////////////////////

-(void)handleInviteFromGameCenter:(NSArray *)playersToInvite
{
    [_presentingViewController dismissViewControllerAnimated:YES completion:nil];
    GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease];
    request.playersToInvite = playersToInvite;
    request.maxPlayers = 2;
    request.minPlayers = 2;
    GKTurnBasedMatchmakerViewController *viewController = [[GKTurnBasedMatchmakerViewController alloc]initWithMatchRequest:request];
    viewController.showExistingMatches = NO;
    viewController.turnBasedMatchmakerDelegate = self;
    [_presentingViewController presentViewController:viewController animated:YES completion:nil];
}

-(void)handleTurnEventForMatch:(GKTurnBasedMatch *)match didBecomeActive:(BOOL)didBecomeActive
{
    NSLog(@"Turn has happened");
    if ([match.matchID isEqualToString:self.currentMatch.matchID])
    {
        if ([self isMyTurn] == YES)
        {
            // it's the current match and it's our turn now
            self.currentMatch = match;
            [self.delegate enterExistingGame:match];
        }
        else
        {
            // it's the current match, but it's someone else's turn
            self.currentMatch = match;
            [self.delegate layoutMatch:match];
        }
    }
    else
    {
        if ([self isMyTurn] == YES)
        {
            [self.delegate sendNotice:@"It's your turn for another match" forMatch:match];
        }
        else
        {
            // it's the not current match, and it's someone else's
            // turn
        }
    }
}

-(void)handleMatchEnded:(GKTurnBasedMatch *)match
{
    NSLog(@"Game has ended");
    if ([match.matchID isEqualToString:self.currentMatch.matchID])
    {
        [self.delegate recieveEndGame:match];
    }
    else
    {
        [self.delegate sendNotice:@"Another Game Ended!" forMatch:match];
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark GKTurnBasedMatchmakerViewControllerDelegate
//////////////////////////////////////////////////////////////////////////

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController
                            didFindMatch:(GKTurnBasedMatch *)match
{
    [_presentingViewController dismissViewControllerAnimated:YES completion:nil];
    self.currentMatch = match;
    GKTurnBasedParticipant *firstParticipant = [match.participants objectAtIndex:0];
    if (firstParticipant.lastTurnDate != nil)
    {
        if ([match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            if ([self.delegate respondsToSelector:@selector(enterExistingGame:)])
            {
                [self.delegate enterExistingGame:match];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(layoutMatch:)])
            {
                [self.delegate layoutMatch:match];
            }
        }
        
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(enterNewGame:)])
        {
            [self.delegate enterNewGame:match];
        }
    }
    
    
}

-(void)turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController
{
    [_presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController
                        didFailWithError:(NSError *)error
{
    [_presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController
                      playerQuitForMatch:(GKTurnBasedMatch *)match
{
    NSUInteger currentIndex = [match.participants indexOfObject:match.currentParticipant];
    GKTurnBasedParticipant *part;
    
    for (int i = 0; i < [match.participants count]; i++) {
        part = [match.participants objectAtIndex:
                (currentIndex + 1 + i) % match.participants.count];
        if (part.matchOutcome != GKTurnBasedMatchOutcomeQuit) {
            break;
        }
    }
    
    [match participantQuitInTurnWithOutcome:GKTurnBasedMatchOutcomeQuit
                           nextParticipants:@[part]
                                turnTimeout:0
                                  matchData:match.matchData
                          completionHandler:nil];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (BOOL)isMyTurn
{
    return [_currentMatch.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID] == YES;
}

- (void)findMatchWithPresentingViewController:(UIViewController *)presentingViewConroller
{
    if (self.gameCenterAvailable == YES)
    {
        
        _presentingViewController = presentingViewConroller;
        
        GKMatchRequest *request = [[GKMatchRequest alloc] init];
        request.minPlayers = 2;
        request.maxPlayers = 2;
        
        GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc]initWithMatchRequest:request];
        mmvc.turnBasedMatchmakerDelegate = self;
        mmvc.showExistingMatches = YES;
        
        [presentingViewConroller presentViewController:mmvc animated:YES completion:nil];
        [mmvc release];
        [request release];
    }
}

- (void)authenticateLocalUserWithHandler:(void (^)(UIViewController* viewController, NSError *error))handler
{
    if (self.gameCenterAvailable == YES)
    {
        
        void (^setGKEventHandlerDelegate)(NSError *) = ^ (NSError *error)
        {
            GKTurnBasedEventHandler *ev = [GKTurnBasedEventHandler sharedTurnBasedEventHandler];
            ev.delegate = self;
        };
        
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];

        if ([GKLocalPlayer localPlayer].authenticated == NO)
        {
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            {
                localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
                    handler(viewController, error);
                    setGKEventHandlerDelegate(error);
                };
            }
            else
            {
                [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
                    handler(nil,error);
                    setGKEventHandlerDelegate(error);
                }];
            }
        }
        else
        {
            NSLog(@"Already authenticated!");
            setGKEventHandlerDelegate(nil);
        }
    }
}

@end
