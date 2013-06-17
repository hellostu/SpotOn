//
//  SOGameResultViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 16/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOGameResultViewController.h"
#import "SOCodeDisplayView.h"

@interface SOGameResultViewController ()
{
    SOGameResult    _winType;
    NSArray         *_player1Code;
    NSArray         *_player2Code;
}

@end

@implementation SOGameResultViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithWinType:(SOGameResult)winType player1Code:(NSArray *)player1Code player2Code:(NSArray *)player2Code
{
    if ( (self = [super init]) != nil)
    {
        _winType = winType;
        _player1Code = [player1Code retain];
        _player2Code = [player2Code retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    switch (_winType)
    {
        case SOGameResultPlayerOneWin:
        {
            self.messageView.text = @"PLAYER 1 WINS!";
            break;
        }
        case SOGameResultPlayerTwoWin:
        {
            self.messageView.text = @"PLAYER 2 WINS!";
            break;
        }
        case SOGameResultDraw:
        {
            self.messageView.text = @"IT'S A DRAW!";
            break;
        }
            
        default:
            break;
    }
    
    SOCodeDisplayView *player1CodeDisplay = [[SOCodeDisplayView alloc] initWithCode:_player1Code];
    SOCodeDisplayView *player2CodeDisplay = [[SOCodeDisplayView alloc] initWithCode:_player2Code];
    
    player1CodeDisplay.center = CGPointMake(self.view.frame.size.width/2, 250);
    player2CodeDisplay.center = CGPointMake(self.view.frame.size.width/2, 350);
    
    [self.view addSubview:player1CodeDisplay];
    [self.view addSubview:player2CodeDisplay];
    
    [player1CodeDisplay release];
    [player2CodeDisplay release];
}

- (void)dealloc
{
    [_player1Code release];
    [_player2Code release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
