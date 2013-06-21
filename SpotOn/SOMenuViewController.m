//
//  SOMenuViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 18/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOMenuViewController.h"
#import "SOGameCenterHelper.h"

@interface SOMenuViewController ()
{
    UITableView *_gamesTable;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_gamesTable release];
    [super dealloc];
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

@end
