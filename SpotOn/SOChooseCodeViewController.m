//
//  SLChooseCodeViewController.m
//  DotGame
//
//  Created by Stuart Lynch on 15/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOChooseCodeViewController.h"
#import "SOCodeSelectionView.h"
#import "SOButton.h"
#import "SOGuessFeedbackIndicator.h"
#import "SODialogView.h"

@interface SOChooseCodeViewController () <SOButtonDelegate, SOCodeSelectionViewDelegate>
{
    SOCodeSelectionView *_codeSelectionView;
    SOButton            *_submitButton;
    SOButton            *_backButton;
    
    int     numberOfColors;
    int     numberOfRecepticles;
}

@end

@implementation SOChooseCodeViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithPlayType:(SOPlayType)playType difficulty:(SODifficulty)difficulty
{
    if ( (self = [super init]) != nil)
    {
         _playerType = playType;
        
        switch (difficulty)
        {
            case SODifficultyEasy:
            {
                numberOfColors = 4;
                numberOfRecepticles = 4;
                break;
            }
            case SODifficultyMedium:
            {
                numberOfColors = 6;
                numberOfRecepticles = 4;
                break;
            }
            case SODifficultyHard:
            default:
            {
                numberOfColors = 6;
                numberOfRecepticles = 5;
                break;
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    switch (self.playerType)
    {
        case SOPlayTypePassAndPlayPlayerOne:
        {
            self.messageView.text = @"PLAYER 1\n SELECT A CODE FOR YOUR OPPONENT:";
            break;
        }
        case SOPlayTypePassAndPlayPlayerTwo:
        {
            self.messageView.text = @"PLAYER 2\n SELECT A CODE FOR YOUR OPPONENT:";
            break;
        }
        case SOPlayTypeGameCenter:
        {
            self.messageView.text = @"SELECT A CODE FOR YOUR OPPONENT";
        }
        default:
            break;
    }
    
    self.messageView.frame = CGRectMake(0, 70, self.view.frame.size.width,100);
    
    _codeSelectionView = [[SOCodeSelectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.35)
                                                     numberOfColors:numberOfColors
                                                numberOfRecepticles:numberOfRecepticles
                                                           useHoles:NO];
    _codeSelectionView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.68);
    _codeSelectionView.delegate = self;
    
    CGFloat y = self.view.frame.size.height*0.92;
    _backButton = [[SOButton alloc] initWithType:SOButtonTypeBack];
    _backButton.delegate = self;
    _backButton.center = CGPointMake(self.view.frame.size.width/2-50, y);
    [self.view addSubview:_backButton];
    
    _submitButton = [[SOButton alloc] initWithType:SOButtonTypeSubmit];
    _submitButton.delegate = self;
    _submitButton.center = CGPointMake(self.view.frame.size.width/2+50, y);
    _submitButton.alpha = 0.0f;
    [self.view addSubview:_submitButton];
    
    [self.view addSubview:_codeSelectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_codeSelectionView release];
    [_submitButton release];
    [_backButton release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SLCodeSelectionViewDelegate
//////////////////////////////////////////////////////////////////////////

- (void)codeSelectionViewWillChangeRecepticles:(SOCodeSelectionView *)codeSelectionView
{
    if ([codeSelectionView recepticlesPopulated] == YES)
    {
        [UIView animateWithDuration:0.2 animations:^() {
            _submitButton.alpha = 1.0f;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^() {
            _submitButton.alpha = 0.0f;
        }];
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SLSubmitButtonDelegate
//////////////////////////////////////////////////////////////////////////

- (void)buttonPressed:(SOButton *)button
{
    if (button == _backButton)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([self.delegate respondsToSelector:@selector(chooseCodeViewController:didReturnCode:)])
    {
        [self.delegate chooseCodeViewController:self didReturnCode:[_codeSelectionView colorsInRecepticles]];
    }
}

@end
