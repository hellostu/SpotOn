//
//  SOMenuViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 18/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOGameListViewController.h"
#import "SOGameCenterHelper.h"
#import "SOGameCenterViewController.h"
#import "GKTurnBasedMatch+otherParticipant.h"
#import "SOGameListCell.h"
#import "SOProfilePicture.h"
#import "SOGameListHeader.h"

@interface SOGameListViewController () <UITableViewDataSource, UITableViewDelegate, SOGamerCenterHelperDelegate, SOGameListCellDelegate>
{
    UITableView             *_gamesTable;

    NSMutableArray          *_matchesInvitations;
    NSMutableArray          *_matchesInvited;
    NSMutableArray          *_matchesActive;
    NSMutableArray          *_matchesEnded;
    
    NSMutableArray          *_playersInvitations;
    NSMutableArray          *_playersInvited;
    NSMutableArray          *_playersActive;
    NSMutableArray          *_playersEnded;
    
    NSMutableDictionary      *_photos;
    
    BOOL                    _processingMatches;
    
    UIButton                *_gameCenterButton;
    
    int                     _loadPlayersCount;
    
    SOGameCenterViewController  *_currentGameCenterGame;
}
@end

@implementation SOGameListViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)init
{
    if (self = [super init])
    {
        _matchesInvitations = [[NSMutableArray alloc] init];
        _matchesActive = [[NSMutableArray alloc] init];
        _matchesInvited = [[NSMutableArray alloc] init];
        _matchesEnded = [[NSMutableArray alloc] init];
        
        _playersInvitations = [[NSMutableArray alloc] init];
        _playersActive = [[NSMutableArray alloc] init];
        _playersInvited = [[NSMutableArray alloc] init];
        _playersEnded = [[NSMutableArray alloc] init];
        
        _photos = [[NSMutableDictionary alloc] init];
        
        _processingMatches = NO;
        _loadPlayersCount = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_gamesTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, self.view.frame.size.height-35)];
    _gamesTable.dataSource = self;
    _gamesTable.delegate = self;
    _gamesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _gameCenterButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    _gameCenterButton.frame = CGRectMake(0, 0, 130, 30);
    _gameCenterButton.center = CGPointMake(self.view.frame.size.width-70, 20);
    [_gameCenterButton setTitle:@"Game Center" forState:UIControlStateNormal];
    [_gameCenterButton addTarget:self action:@selector(newGamePressed) forControlEvents:UIControlEventTouchUpInside];
    _gameCenterButton.enabled = NO;
    
    self.view.backgroundColor = GREY_COLOR_BTM_BACKGROUND;
    _gamesTable.backgroundColor = GREY_COLOR_BTM_BACKGROUND;
    
    [self.view addSubview:_gamesTable];
    [self.view addSubview:_gameCenterButton];
    [self pullMatches];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self pullMatches];
    [SOGameCenterHelper sharedInstance].delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_gameCenterButton release];
    [_gamesTable release];
    [_playersActive release];
    [_playersEnded release];
    [_playersInvitations release];
    [_playersInvited release];
    [_matchesActive release];
    [_matchesEnded release];
    [_matchesInvitations release];
    [_matchesInvited release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDatasource
//////////////////////////////////////////////////////////////////////////

- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return _playersInvitations.count;
            break;
        }
        case 1:
        {
            return _playersActive.count;
            break;
        }
        case 2:
        {
            return _playersInvited.count;
            break;
        }
        case 3:
        default:
        {
            return _playersEnded.count;
            break;
        }
            
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        GKTurnBasedMatch *match = _matchesActive[indexPath.row];
        [[SOGameCenterHelper sharedInstance] quitMatch:match];
        
        [_playersActive removeObjectAtIndex:indexPath.row];
        [_matchesActive removeObjectAtIndex:indexPath.row];
        [_gamesTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return YES;
    }
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SOGameListCell *cell = nil;
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"invite"];
        if (cell == nil)
        {
            cell = [[SOGameListCell alloc] initWithType:SOGameListCellTypeInvite tableView:tableView reuseIdentifier:@"invite"];
            cell.delegate = self;
            [cell autorelease];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"normal"];
        if (cell == nil)
        {
            cell = [[SOGameListCell alloc] initWithType:SOGameListCellTypeNormal tableView:tableView reuseIdentifier:@"normal"];
            [cell autorelease];
        }
    }
    
    
    
    NSArray *players = nil;
    NSArray *matches = nil;
    
    switch (indexPath.section)
    {
        case 0:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            players = _playersInvitations;
            GKPlayer *player = players[indexPath.row];
            
            cell.textLabel.text = @"CHALLENGE";
            cell.detailTextLabel.text = player.displayName.uppercaseString;
            break;
        }
        case 1:
        {
            players = _playersActive;
            matches = _matchesActive;
            if (indexPath.row < players.count)
            {
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                
                GKPlayer *player = players[indexPath.row];
                
                
                GKTurnBasedMatch *match = matches[indexPath.row];
                if([match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID] == YES)
                {
                    cell.textLabel.text = @"YOUR TURN";
                }
                else
                {
                    cell.textLabel.text = @"THEIR TURN";
                }
                if (player.displayName != nil)
                {
                    cell.detailTextLabel.text = player.displayName.uppercaseString;
                }
                else
                {
                    cell.detailTextLabel.text = @"WAITING FOR MATCH";
                }
            }
            else
            {
                cell.textLabel.text = @"LOADING...";
            }
            break;
        }
        case 2:
        {
            players = _playersInvited;
            if (indexPath.row < players.count)
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                GKPlayer *player = players[indexPath.row];
                
                cell.textLabel.text = @"INVITED";
                cell.detailTextLabel.text = player.displayName.uppercaseString;
            }
            else
            {
                cell.textLabel.text = @"LOADING...";
            }
            break;
        }
        case 3:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            players = _playersEnded;
            matches = _matchesEnded;
            if (indexPath.row < players.count)
            {
                GKPlayer *player = players[indexPath.row];
                GKTurnBasedMatch *match = matches[indexPath.row];
                
                switch(match.localParticipant.matchOutcome)
                {
                    case GKTurnBasedMatchOutcomeQuit:
                    {
                        cell.textLabel.text = @"GAME QUIT";
                        break;
                    }
                    case GKTurnBasedMatchOutcomeWon:
                    {
                        cell.textLabel.text = @"GAME WON";
                        break;
                    }
                    case GKTurnBasedMatchOutcomeLost:
                    {
                        cell.textLabel.text = @"GAME LOST";
                        break;
                    }
                    case GKTurnBasedMatchOutcomeTied:
                    {
                        cell.textLabel.text = @"GAME TIED";
                        break;
                    }
                    default:
                    {
                        switch (match.otherParticipant.matchOutcome)
                        {
                            case GKTurnBasedMatchOutcomeQuit:
                            {
                                cell.textLabel.text = @"GAME WON";
                                break;
                            }
                            case GKTurnBasedMatchOutcomeWon:
                            {
                                cell.detailTextLabel.text = @"GAME LOST";
                                break;
                            }
                            case GKTurnBasedMatchOutcomeLost:
                            {
                                cell.detailTextLabel.text = @"GAME WON";
                                break;
                            }
                            case GKTurnBasedMatchOutcomeTied:
                            {
                                cell.textLabel.text = @"GAME TIED";
                                break;
                            }
                            default:
                            {
                                cell.detailTextLabel.text = @"GAME OVER";
                            }
                        }
                        break;
                    }
                }
                cell.detailTextLabel.text = player.displayName.uppercaseString;
            }
            else
            {
                cell.textLabel.text = @"Loading...";
                
            }
            break;
        }
            
    }
    UIImage *photo = nil;
    if (indexPath.row < players.count)
    {
        GKPlayer *player = players[indexPath.row];
        if (player.playerID != nil)
        {
            photo = _photos[player.playerID];
        }
        
        if (photo == nil)
        {
            [player loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *image, NSError *error) {
                if (image == nil)
                {
                    _photos[player.playerID] = [UIImage imageNamed:@"avatar_head_set.png"];
                }
                else
                {
                    _photos[player.playerID] = image;
                    cell.profilePicture.imageView.image = image;
                }
            }];
        }
        else
        {
            cell.profilePicture.imageView.image = photo;
        }
    }
    
    
    return cell;
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDelegate
//////////////////////////////////////////////////////////////////////////

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SOGameListHeader *header = [[SOGameListHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40.0f)];
    switch (section)
    {
        case 0:
        {
            header.textLabel.text = @"INVITATIONS";
            break;
        }
        case 1:
        {
            header.textLabel.text = @"ACTIVE GAMES";
            break;
        }
        case 2:
        {
            header.textLabel.text = @"INVITED";
            break;
        }
        case 3:
        default:
        {
            header.textLabel.text = @"MATCHES ENDED";
            break;
        }
            
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *players = nil;
    switch (section)
    {
        case 0:
        {
            players = _playersInvitations;
            break;
        }
        case 1:
        {
            players = _playersActive;
            break;
        }
        case 2:
        {
            players = _playersInvitations;
            break;
        }
        case 3:
        default:
        {
            players = _playersEnded;
            break;
        }
    }
    if (players.count > 0)
    {
        return 40;
    }
    else
    {
        return  0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *matches = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            matches = _matchesInvitations;
            break;
        }
        case 1:
        {
            matches = _matchesActive;
            break;
        }
        case 2:
        {
            matches = _matchesInvited;
            break;
        }
        case 3:
        default:
        {
            matches = _matchesEnded;
            break;
        }
            
    }
    
    if (matches == _matchesActive && indexPath.row < _matchesActive.count)
    {
        SOGameCenterHelper *gameCenterHelper = [SOGameCenterHelper sharedInstance];
        GKTurnBasedMatch *match = matches[indexPath.row];
        [gameCenterHelper initiateWithMatch:match];
    }
    [_gamesTable deselectRowAtIndexPath:indexPath animated:YES];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOGameListCellDelegate
//////////////////////////////////////////////////////////////////////////

- (void)gameListCell:(SOGameListCell *)gameListCell didAcceptInviteAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<_matchesInvitations.count)
    {
        GKTurnBasedMatch *match = _matchesInvitations[indexPath.row];
        [match acceptInviteWithCompletionHandler:^(GKTurnBasedMatch *match, NSError *error)
         {
             [[SOGameCenterHelper sharedInstance] initiateWithMatch:match];
         }];
        [_matchesInvitations removeObjectAtIndex:indexPath.row];
        [_playersInvitations removeObjectAtIndex:indexPath.row];
        [_gamesTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)gameListCell:(SOGameListCell *)gameListCell didDeclineInviteAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<_matchesInvitations.count)
    {
        GKTurnBasedMatch *match = _matchesInvitations[indexPath.row];
        [match declineInviteWithCompletionHandler:^(NSError *error)
         {
             
         }];
        [_matchesInvitations removeObjectAtIndex:indexPath.row];
        [_playersInvitations removeObjectAtIndex:indexPath.row];
        [_gamesTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOGameCenterHelperDelegate
//////////////////////////////////////////////////////////////////////////

- (void)enterNewGame:(GKTurnBasedMatch *)match
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    SOGameCenterViewController *gameCenter = [[SOGameCenterViewController alloc] initWithGameType:SOGameTypeNewGame];
    [self.navigationController pushViewController:gameCenter animated:YES];
    
    [gameCenter release];
}
- (void)layoutMatch:(GKTurnBasedMatch *)match
{
    SOGameCenterViewController *gameCenter = [[SOGameCenterViewController alloc] initWithGameType:SOGameTypeExistingGame];
    [self.navigationController pushViewController:gameCenter animated:YES];
    [gameCenter release];
}
- (void)enterExistingGame:(GKTurnBasedMatch *)match
{
    [self pullMatches];
}
- (void)recieveEndGame:(GKTurnBasedMatch *)match
{
    [self pullMatches];
}
- (void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match
{
    [self pullMatches];
}

- (void)authenticationChanged:(SOGameCenterHelper *)gameCenterHelper
{
    if (gameCenterHelper.userAuthenticated == YES)
    {
        _gameCenterButton.enabled = YES;
    }
    else
    {
        _gameCenterButton.enabled = NO;
    }
}

- (void)opponentQuit:(GKTurnBasedMatch *)match
{
    [self pullMatches];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions
//////////////////////////////////////////////////////////////////////////

- (void)newGamePressed
{
    SOGameCenterHelper *gameCenterHelper = [SOGameCenterHelper sharedInstance];
    [gameCenterHelper findMatchWithPresentingViewController:self];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (void)pullMatches
{
    if(_processingMatches == NO)
    {
        _processingMatches = YES;
        
        [_matchesActive removeAllObjects];
        [_matchesInvitations removeAllObjects];
        [_matchesInvited removeAllObjects];
        [_matchesEnded removeAllObjects];
        
        [_playersActive removeAllObjects];
        [_playersInvited removeAllObjects];
        [_playersInvitations removeAllObjects];
        [_playersEnded removeAllObjects];
        
        [[SOGameCenterHelper sharedInstance] authenticateLocalUserWithHandler:^(UIViewController *viewController, NSError *error) {
            if (viewController != nil)
            {
                [self presentViewController:viewController
                                   animated:YES
                                 completion:nil];
            }
            [[SOGameCenterHelper sharedInstance] loadMatchesWithCompletionHandler:^(NSArray *matches, NSError *error)
             {
                 [_matchesActive removeAllObjects];
                 [_matchesInvitations removeAllObjects];
                 [_matchesInvited removeAllObjects];
                 
                 for (GKTurnBasedMatch *match in matches)
                 {
                     BOOL isMyTurn = [match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID];
                     
                     GKTurnBasedMatchOutcome outcome1 = match.otherParticipant.matchOutcome;
                     GKTurnBasedMatchOutcome outcome2 = match.localParticipant.matchOutcome;
                     
                     if (outcome1 == GKTurnBasedMatchOutcomeNone &&
                         outcome2 == GKTurnBasedMatchOutcomeNone)
                     {
                         if (match.status == GKTurnBasedMatchStatusOpen)
                         {
                             if (match.currentParticipant.status == GKTurnBasedParticipantStatusInvited)
                             {
                                 if (isMyTurn == YES)
                                 {
                                     [_matchesInvitations addObject:match];
                                 }
                                 else
                                 {
                                     [_matchesInvited addObject:match];
                                 }
                             }
                             else if(match.localParticipant.status == GKTurnBasedParticipantStatusActive &&
                                     match.otherParticipant.status == GKTurnBasedParticipantStatusActive)
                             {
                                 [_matchesActive addObject:match];
                             }
                         }
                         else if(match.status == GKTurnBasedMatchStatusMatching)
                         {
                             [_matchesActive addObject:match];
                         }
                         else if(match.status == GKTurnBasedMatchStatusEnded)
                         {
                             [_matchesEnded addObject:match];
                         }
                     }
                     else if( (outcome1 == GKTurnBasedMatchOutcomeQuit && outcome2 == GKTurnBasedMatchOutcomeNone)  )
                     {
                         match.localParticipant.matchOutcome = GKTurnBasedMatchOutcomeWon;
                         match.otherParticipant.matchOutcome = GKTurnBasedMatchOutcomeQuit;
                         

                         
                        
                         if (match.status != GKTurnBasedMatchStatusEnded)
                         {
                             [match endMatchInTurnWithMatchData:match.matchData completionHandler:^(NSError *error) {
                                 if (error != nil)
                                 {
                                     NSLog(@"Error:%@", error);
                                 }
                             }];
                         }
                         
                         [_matchesEnded addObject:match];
                     }
                     else
                     {
                         [_matchesEnded addObject:match];
                     }
                 }
                 NSComparator comparator = ^(id obj1, id obj2) {
                     GKTurnBasedMatch *match1 = (GKTurnBasedMatch *)obj1;
                     GKTurnBasedMatch *match2 = (GKTurnBasedMatch *)obj2;
                     NSDate *date1 = nil;
                     NSDate *date2 = nil;
                     
                     for (GKTurnBasedParticipant *participant in match1.participants)
                     {
                         if (date1 == nil)
                         {
                             date1 = participant.lastTurnDate;
                         }
                         else if([date1 compare:participant.lastTurnDate] == NSOrderedAscending)
                         {
                             date1 = participant.lastTurnDate;
                         }
                     }
                     for (GKTurnBasedParticipant *participant in match2.participants)
                     {
                         if (date2 == nil)
                         {
                             date2 = participant.lastTurnDate;
                         }
                         else if([date2 compare:participant.lastTurnDate] == NSOrderedAscending)
                         {
                             date2 = participant.lastTurnDate;
                         }
                     }
                     
                     return [date2 compare:date1];
                 };
                 if (_matchesEnded.count > 1)
                 {
                     [_matchesEnded sortUsingComparator:comparator];
                 }
                 if (_matchesEnded.count > 10)
                 {
                     while (10<_matchesEnded.count)
                     {
                         GKTurnBasedMatch *match = _matchesEnded[10];
                         match.localParticipant.matchOutcome = GKTurnBasedMatchStatusEnded;
                         match.otherParticipant.matchOutcome = GKTurnBasedMatchStatusEnded;
                         
                         [match removeWithCompletionHandler:^(NSError *error) {
                             if (error != nil)
                             {
                                 NSLog(@"Error:%@", error);
                             }
                         }];
                         [_matchesEnded removeObjectAtIndex:10];
                     }
                 }
                 if (_matchesActive.count > 1)
                 {
                     [_matchesActive sortUsingComparator:comparator];
                 }
                 [self processMatches];
             }];
        }];
    }
}

- (void)processMatches
{
    [self processMatches:_matchesActive intoPlayers:_playersActive];
    [self processMatches:_matchesInvitations intoPlayers:_playersInvitations];
    [self processMatches:_matchesInvited intoPlayers:_playersInvited];
    [self processMatches:_matchesEnded intoPlayers:_playersEnded];
}

- (void)processMatches:(NSArray *)matches intoPlayers:(NSMutableArray *)playersArray
{
    NSMutableArray *playerIDs = [[NSMutableArray alloc] initWithCapacity:matches.count];
    
    if(matches != nil)
    {
        for (GKTurnBasedMatch *match in matches)
        {
            GKTurnBasedParticipant *participant1 = match.participants[0];
            GKTurnBasedParticipant *participant2 = match.participants[1];
            
            if ([participant1.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID] == YES)
            {
                if (participant2.playerID != nil)
                {
                    [playerIDs addObject:participant2.playerID];
                }
                else
                {
                    [playerIDs addObject:@"NOMATCH"];
                }
            }
            else
            {
                [playerIDs addObject:participant1.playerID];
            }
        }
        
    }
    [GKPlayer loadPlayersForIdentifiers:playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
        [playersArray removeAllObjects];
        [playersArray addObjectsFromArray:players];
        _loadPlayersCount++;
        if (_loadPlayersCount==4)
        {
            _loadPlayersCount = 0;
            _processingMatches = NO;
            [_gamesTable reloadData];
        }
        
    }];
    [playerIDs release];
}

@end
