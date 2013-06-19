//
//  SOMenuViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 18/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOMenuViewController.h"

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
    

    
    [self.view addSubview:_gamesTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [_gamesTable release];
}

@end
