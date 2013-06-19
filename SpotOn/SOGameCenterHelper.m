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
#pragma mark GKTurnBasedMatchmakerViewControllerDelegate
//////////////////////////////////////////////////////////////////////////

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController
                            didFindMatch:(GKTurnBasedMatch *)match
{
    [_presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"did find match, %@", match);
}

-(void)turnBasedMatchmakerViewControllerWasCancelled:
(GKTurnBasedMatchmakerViewController *)viewController
{
    [_presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"has cancelled");
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController
                        didFailWithError:(NSError *)error
{
    [_presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController
                      playerQuitForMatch:(GKTurnBasedMatch *)match
{
    NSLog(@"playerquitforMatch, %@, %@",match, match.currentParticipant);
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (void)findMatchWithPresentingViewController:(UIViewController *)presentingViewConroller
{
    if (self.gameCenterAvailable == YES)
    {
        
        _presentingViewController = presentingViewConroller;
        
        GKMatchRequest *request = [[GKMatchRequest alloc] init];
        request.minPlayers = 2;
        request.maxPlayers = 2;
        
        GKTurnBasedMatchmakerViewController *mmvc =
        [[GKTurnBasedMatchmakerViewController alloc]
         initWithMatchRequest:request];
        mmvc.turnBasedMatchmakerDelegate = self;
        mmvc.showExistingMatches = YES;
        
        [presentingViewConroller presentViewController:mmvc animated:YES completion:nil];
    }
}

- (void)authenticateLocalUserWithHandler:(void (^)(UIViewController* viewController, NSError *error))handler
{
    if (self.gameCenterAvailable == NO)
    {
        return;
    }
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    NSLog(@"Authenticating local user...");
    if (localPlayer.authenticated == NO)
    {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            localPlayer.authenticateHandler = handler;
        }
        else
        {
            [localPlayer authenticateWithCompletionHandler:nil];
        }
        
    }
    else
    {
        NSLog(@"Already authenticated!");
    }
}

@end
