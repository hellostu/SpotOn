
//
//  SLGameViewController.m
//  Mastermind
//
//  Created by Stuart Lynch on 13/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOGameViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SOGameCenterHelper.h"

@interface SOGameViewController () <SOCodeSelectionViewDelegate, SOButtonDelegate>
{
    BOOL    _submitButtonAnimating;
    BOOL    _animatingTakingTurn;
    
    int     _numberOfColors;
    int     _numberOfRecepticles;
    
    UIView                      *_loadingView;
    UIActivityIndicatorView     *_activityIndicator;
}
@end

@implementation SOGameViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithPlayType:(SOPlayType)playType difficulty:(SODifficulty)difficulty code:(NSArray *)code
{
    if ( (self = [super init]) != nil)
    {
        _gameState = SOGameStateWaitingForGuess;
        _playType = playType;
        _code = [code retain];
        
        switch (difficulty)
        {
            case SODifficultyEasy:
            {
                _numberOfColors = 4;
                _numberOfRecepticles = 4;
                break;
            }
            case SODifficultyMedium:
            {
                _numberOfColors = 6;
                _numberOfRecepticles = 4;
                break;
            }
            case SODifficultyHard:
            default:
            {
                _numberOfColors = 6;
                _numberOfRecepticles = 5;
                break;
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GREY_COLOR_BTM_BACKGROUND;
    
    _codeSelectionView = [[SOCodeSelectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.35)
                                                     numberOfColors:_numberOfColors
                                                numberOfRecepticles:_numberOfRecepticles];
    _codeSelectionView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.68);
    _codeSelectionView.delegate = self;
    
    _submitButton = [[SOButton alloc] initWithType:SOButtonTypeSubmit];
    _submitButton.delegate = self;
    _submitButton.alpha = 0.0f;
    CGFloat y = (self.view.frame.size.height-(_codeSelectionView.frame.size.height+_codeSelectionView.frame.origin.y))/2;
    y = self.view.frame.size.height-y;
    _submitButton.center = CGPointMake(self.view.frame.size.width/2, y-5);
    [self.view addSubview:_submitButton];
    
    _previousGuessesView = [[SOPreviousGuessesView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height/2) numberOfRecepticles:_numberOfRecepticles];
    [_previousGuessesView scrollToEndAnimated:NO withCompletion:nil];
    if ([self.delegate respondsToSelector:@selector(gameViewControllerDidLoadViews:)])
    {
        [self.delegate gameViewControllerDidLoadViews:self];
    }
    
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _loadingView.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.2 alpha:0.4];
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    UIView *roundedSquare = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    roundedSquare.layer.cornerRadius = 10.0f;
    roundedSquare.center = CGPointMake(_loadingView.frame.size.width/2, _loadingView.frame.size.height/2);
    roundedSquare.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9];
    _activityIndicator.center = CGPointMake(50, 50);
    
    [roundedSquare addSubview:_activityIndicator];
    [_loadingView addSubview:roundedSquare];
    [roundedSquare release];
    
    _loadingView.alpha = 0.0f;
    
    //[self.view addSubview:imageView];
    [self.view addSubview:_submitButton];
    [self.view addSubview:_previousGuessesView];
    [self.view addSubview:_codeSelectionView];
    [self.view addSubview:_loadingView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([_codeSelectionView recepticlesPopulated] == NO)
    {
        _submitButton.alpha = 0.0f;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.playType != SOPlayTypeGameCenter || [[SOGameCenterHelper sharedInstance] isMyTurn])
    {
        [_previousGuessesView addNewRowAnimated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _codeSelectionView.alpha = 1.0f;
    _submitButton.alpha = 0.0f;
}

- (void)dealloc
{
    [_codeSelectionView release];
    [_previousGuessesView release];
    [_code release];
    [_submitButton release];
    [_loadingView release];
    [_activityIndicator release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOCodeSelectionViewDelegate
//////////////////////////////////////////////////////////////////////////

- (void)codeSelectionViewWillChangeRecepticles:(SOCodeSelectionView *)codeSelectionView
{
    [self updateSubmitButton];
}

- (void)codeSelectionViewDidChangeRecepticles:(SOCodeSelectionView *)codeSelectionView
{
    if (_playType == SOPlayTypeGameCenter)
    {
        NSArray *code = [codeSelectionView colorsInRecepticles];
        [[SOGameCenterHelper sharedInstance] saveColorsInRecepticles:code];
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SLSubmitButtonDelegate
//////////////////////////////////////////////////////////////////////////

- (void)buttonPressed:(SOButton *)submitButton
{
    if (_submitButtonAnimating == NO)
    {
        if (self.playType != SOPlayTypeGameCenter)
        {
            if (self.playType != SOPlayTypeSinglePlayer) // Is Pass and Play Game
            {
                [self hideSubmitButton];
                switch (self.gameState)
                {
                    case SOGameStateWaitingForGuess:
                    {
                        [self submitTurn];
                        
                        break;
                    }
                    case SOGameStateGuessInput:
                    {
                        [self.delegate gameViewControllerReadyToTransition:self];
                        _gameState = SOGameStateWaitingForGuess;
                        break;
                    }
                    default:
                        break;
                }
            }
            else
            {
                [self submitTurn];
            }
        }
        else if([[SOGameCenterHelper sharedInstance] isMyTurn] == YES)
        {
            if ([self.delegate respondsToSelector:@selector(gameViewController:requestedToSendTurnWithCode:)])
            {
                NSArray *colorsOfCurrentTurn = [self.codeSelectionView colorsInRecepticles];
                [self.delegate gameViewController:self requestedToSendTurnWithCode:colorsOfCurrentTurn];
            }
            _submitButtonAnimating = YES;
            [UIView animateWithDuration:0.2 animations:^() {
                submitButton.alpha = 0.0;
            } completion:^(BOOL finished) {
                _submitButtonAnimating = NO;
            }];
        }
        else
        {
            _submitButtonAnimating = YES;
            [UIView animateWithDuration:0.2 animations:^(){
                _submitButton.alpha = 0.0f;
            } completion:^(BOOL finished) {
                _submitButtonAnimating = NO;
            }];
        }
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (void)startLoading
{
    [_activityIndicator startAnimating];
    [UIView animateWithDuration:0.2 animations:^() {
        _loadingView.alpha = 1.0f;
    }];
}

- (void)stopLoading
{
    [UIView animateWithDuration:0.2 animations:^() {
        _loadingView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [_activityIndicator stopAnimating];
    }];
}

- (void)updateSubmitButton
{
    if ([_codeSelectionView recepticlesPopulated] == YES)
    {
        if (self.playType != SOPlayTypeGameCenter || ([[SOGameCenterHelper sharedInstance] isMyTurn] == YES && _submitButtonAnimating == NO))
        {
            [self showSubmitButton];
        }
        else
        {
            [self hideSubmitButton];
        }
    }
    else
    {
        [self hideSubmitButton];
    }
}

- (void)showSubmitButton
{
    _submitButtonAnimating = YES;
    [UIView animateWithDuration:0.2 animations:^() {
        _submitButton.alpha = 1.0f;
    } completion:^(BOOL finished) {
        _submitButtonAnimating = NO;
    }];
}

- (void)hideSubmitButton
{
    _submitButtonAnimating = YES;
    [UIView animateWithDuration:0.2 animations:^() {
        _submitButton.alpha = 0.0f;
    } completion:^(BOOL finished) {
        _submitButtonAnimating = NO;
    }];
}

- (void)submitTurn
{
    if([_codeSelectionView recepticlesPopulated] == YES)
    {
        _submitButtonAnimating = YES;
        [_previousGuessesView scrollToEndAnimated:YES withCompletion:^() {
            [_codeSelectionView submitAllCirclesWithCompletion:^(NSArray *colors){
                [_previousGuessesView takeTurnWithColors:colors];
                if ([self.delegate respondsToSelector:@selector(gameViewController:didTakeTurnWithCode:)])
                {
                    [self.delegate gameViewController:self didTakeTurnWithCode:colors];
                }
                
                if (self.playType == SOPlayTypeSinglePlayer)
                {
                    
                }
                else if (self.playType != SOPlayTypeGameCenter)
                {
                    [UIView animateWithDuration:0.2 animations:^() {
                        _codeSelectionView.alpha = 0.0f;
                    }];
                }
                else
                {
                    NSMutableArray *emptyCode = [NSMutableArray arrayWithCapacity:_numberOfRecepticles];
                    for (int i=0; i<_numberOfRecepticles; i++)
                    {
                        [emptyCode addObject:@(-1)];
                    }
                    [[SOGameCenterHelper sharedInstance] saveColorsInRecepticles:emptyCode];
                }
                
                //[self updateSubmitButton];
                _submitButtonAnimating = NO;
            }];
        }];
    }
    _gameState = SOGameStateGuessInput;
}

- (NSArray *)guessHistory
{
    return [_previousGuessesView guessesList];
}

@end
