//
//  SLGameViewController.m
//  Mastermind
//
//  Created by Stuart Lynch on 13/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOGameViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "SOCodeSelectionView.h"
#import "SOGameCenterHelper.h"

@interface SOGameViewController () <SOCodeSelectionViewDelegate, SOSubmitButtonDelegate>
{
    SOCodeSelectionView     *_codeSelectionView;
}
@end

@implementation SOGameViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithPlayType:(SOPlayType)playType code:(NSArray *)code
{
    if ( (self = [super init]) != nil)
    {
        _gameState = SLGameStateWaitingForGuess;
        _playType = playType;
        _code = [code retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = GREY_COLOR_BTM_BACKGROUND;
    CGFloat offset = 0;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        offset = 20;
    }
    
	//UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mockup.jpeg"]];
    //imageView.frame = CGRectMake(0, -22, self.view.frame.size.width, self.view.frame.size.height+22);
    
    _codeSelectionView = [[SOCodeSelectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.36-offset)
                                                     numberOfColors:6
                                                numberOfRecepticles:5];
    _codeSelectionView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.65);
    _codeSelectionView.delegate = self;
    
    _submitButton = [[SOButton alloc] initWithType:SOButtonTypeSubmit];
    _submitButton.delegate = self;
    _submitButton.alpha = 0.0f;
    CGFloat y = (self.view.frame.size.height-(_codeSelectionView.frame.size.height+_codeSelectionView.frame.origin.y))/2;
    y = self.view.frame.size.height-y;
    _submitButton.center = CGPointMake(self.view.frame.size.width/2, y);
    [self.view addSubview:_submitButton];
    [_submitButton release];
    
    _previousGuessesView = [[SOPreviousGuessesView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,206+offset)];
    [_previousGuessesView scrollToEndAnimated:NO withCompletion:nil];
    if ([self.delegate respondsToSelector:@selector(gameViewControllerDidLoadViews:)])
    {
        [self.delegate gameViewControllerDidLoadViews:self];
    }
    
    
    //[self.view addSubview:imageView];
    [self.view addSubview:_submitButton];
    [self.view addSubview:_previousGuessesView];
    [self.view addSubview:_codeSelectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.playType != SOPlayTypeGameCenter || [[SOGameCenterHelper sharedInstance] isMyTurn] == NO)
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
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SLCodeSelectionViewDelegate
//////////////////////////////////////////////////////////////////////////

- (void)codeSelectionViewWillChangeRecepticles:(SOCodeSelectionView *)codeSelectionView
{
    BOOL isMyTurn = self.playType != SOPlayTypeGameCenter || [[SOGameCenterHelper sharedInstance] isMyTurn];
    
    if ([codeSelectionView recepticlesPopulated] == YES && isMyTurn == YES)
    {
        _submitButton.enabled = NO;
        [UIView animateWithDuration:0.2 animations:^() {
            _submitButton.alpha = 1.0f;
        } completion:^(BOOL finished) {
            _submitButton.enabled = YES;
        }];
    }
    else
    {
        _submitButton.enabled = NO;
        [UIView animateWithDuration:0.2 animations:^() {
            _submitButton.alpha = 0.0f;
        }];
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SLSubmitButtonDelegate
//////////////////////////////////////////////////////////////////////////

- (void)submitButtonPressed:(SOButton *)submitButton
{
    if (self.playType != SOPlayTypeGameCenter || [[SOGameCenterHelper sharedInstance] isMyTurn] == YES)
    {
        [UIView animateWithDuration:0.2 animations:^() {
            submitButton.alpha = 0.0;
        }];
        switch (self.gameState)
        {
            case SLGameStateWaitingForGuess:
            {
                if([_codeSelectionView recepticlesPopulated] == YES)
                {
                    [_previousGuessesView scrollToEndAnimated:YES withCompletion:^() {
                        [_codeSelectionView submitAllCirclesWithCompletion:^(NSArray *colors){
                            [_previousGuessesView takeTurnWithColors:colors];
                            if ([self.delegate respondsToSelector:@selector(gameViewController:didTakeTurnWithCode:)])
                            {
                                [self.delegate gameViewController:self didTakeTurnWithCode:colors];
                            }
                            
                            if (self.playType != SOPlayTypeGameCenter)
                            {
                                [UIView animateWithDuration:0.2 animations:^() {
                                    _codeSelectionView.alpha = 0.0f;
                                }];
                            }
                        }];
                    }];
                }
                _gameState = SLGameStateGuessInput;
                
                break;
            }
            case SLGameStateGuessInput:
            {
                [self.delegate gameViewControllerReadyToTransition:self];
                _gameState = SLGameStateWaitingForGuess;
                break;
            }
            default:
                break;
        }
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (NSArray *)guessHistory
{
    return [_previousGuessesView guessesList];
}

@end
