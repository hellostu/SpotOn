//
//  SOMenuViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 18/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOMenuViewController.h"
#import "SOGameCenterHelper.h"

@interface SOMenuViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_gamesTable;
    NSArray *_matches;
    NSArray *_players;
}
@end

@implementation SOMenuViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)init
{
    if (self = [super init])
    {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_gamesTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*0.3, self.view.frame.size.width, self.view.frame.size.height*0.7)];
    _gamesTable.dataSource = self;
    
    UIButton *newGameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    newGameButton.frame = CGRectMake(0, 0, 130, 30);
    newGameButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.2);
    [newGameButton setTitle:@"Game Center" forState:UIControlStateNormal];
    [newGameButton addTarget:self action:@selector(newGamePressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_gamesTable];
    [self.view addSubview:newGameButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[SOGameCenterHelper sharedInstance] loadMatchesWithCompletionHandler:^(NSArray *matches, NSError *error)
     {
         [_matches release];
         _matches = nil;
         _matches = [matches retain];
         [self processMatches];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_gamesTable release];
    [_matches release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDatasource
//////////////////////////////////////////////////////////////////////////

- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _players.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"cell"];
        [cell autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    GKPlayer *player = _players[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Match with %@", player.displayName];
    
    GKTurnBasedMatch *match = _matches[indexPath.row];
    if([match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID] == YES)
    {
        cell.detailTextLabel.text = @"Your Turn";
    }
    else
    {
        cell.detailTextLabel.text = @"Their Turn";
    }
    
    return cell;
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

- (void)processMatches
{
    NSMutableArray *playerIDs = [[NSMutableArray alloc] initWithCapacity:_matches.count];
    for (GKTurnBasedMatch *match in _matches)
    {
        GKTurnBasedParticipant *participant1 = match.participants[0];
        GKTurnBasedParticipant *participant2 = match.participants[1];
        
        if ([participant1.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID] == YES)
        {
            [playerIDs addObject:participant2.playerID];
        }
        else
        {
            [playerIDs addObject:participant1.playerID];
        }
    }
    [GKPlayer loadPlayersForIdentifiers:playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
        [_players release];
        _players = nil;
        _players = [players retain];
        [_gamesTable reloadData];
    }];
    [playerIDs release];
}

@end
