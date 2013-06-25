//
//  SOGameResultViewController.m
//  SpotOn
//
//  Created by Stuart Lynch on 22/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOGameResultViewController.h"
#import "SOPreviousGuessView.h"

@interface SOGameResultViewController ()
{
    SOGameResult    _gameResult;
    NSArray         *_ownCode;
    NSArray         *_opponentsCode;
    NSArray         *_ownBestGuess;
    NSArray         *_opponentsBestGuess;
}
@end

@implementation SOGameResultViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithResult:(SOGameResult)gameResult
             ownCode:(NSArray *)ownCode
       opponentsCode:(NSArray *)opponentsCode
        ownBestGuess:(NSArray *)ownBestGuess
  opponentsBestGuess:(NSArray *)opponentsBestGuess
{
    if ( (self = [super init]) != nil)
    {
        _gameResult = gameResult;
        _ownCode = [ownCode retain];
        _opponentsCode = [opponentsCode retain];
        _ownBestGuess = [ownBestGuess retain];
        _opponentsBestGuess = [opponentsBestGuess retain];
        
        _ownProfilePicture = [[SOProfilePicture alloc] initWithType:SOProfilePictureTypeLarge];
        _opponentsProfilePicture = [[SOProfilePicture alloc] initWithType:SOProfilePictureTypeLarge];
    }
    return self;
}

- (void)dealloc
{
    [_ownCode release];
    [_opponentsCode release];
    [_ownBestGuess release];
    [_opponentsBestGuess release];
    [_ownProfilePicture release];
    [_opponentsProfilePicture release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *ownCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.view.frame.size.height/2, self.view.frame.size.width-10, 20)];
    ownCodeLabel.font = [UIFont fontWithName:@"GothamHTF-Medium.png" size:20.0f];
    ownCodeLabel.backgroundColor = GREY_COLOR_TOP_BACKGROUND;
    ownCodeLabel.textColor = GREY_COLOR_TOP_TEXT;
    
    _ownProfilePicture.center = CGPointMake(self.view.frame.size.width*0.3, self.view.frame.size.height*0.35);
    _opponentsProfilePicture.center = CGPointMake(self.view.frame.size.width*0.7, self.view.frame.size.height*0.35);
    
    self.messageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.15);
    
	switch (_gameResult)
    {
        case SOGameResultWin:
        {
            
            self.messageView.text = @"CONGRATULATIONS\nYOU WON!";
            break;
        }
        case SOGameResultLose:
        {
            self.messageView.text = @"OH! YOU WERE\nSO CLOSE!";
            break;
        }
        case SOGameResultTie:
        default:
        {
            self.messageView.text = @"WELL DONE!\nYOU HAVE TIED!";
            break;
        }
    }
    
    [self.view addSubview:_ownProfilePicture];
    [self.view addSubview:_opponentsProfilePicture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
