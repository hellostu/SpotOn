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

@interface SOChooseCodeViewController () <SOSubmitButtonDelegate, SOCodeSelectionViewDelegate>
{
    SOCodeSelectionView *_codeSelectionView;
    SOButton      *_submitButton;
}

@end

@implementation SOChooseCodeViewController

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithPlayType:(SOPlayType)playType
{
    if ( (self = [super init]) != nil)
    {
         _playerType = playType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat offset = 0;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        offset = 22;
    }
    
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
        default:
            break;
    }
    
    self.messageView.frame = CGRectMake(0, 70, self.view.frame.size.width,100);
    
    _codeSelectionView = [[SOCodeSelectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.36-offset)
                                                     numberOfColors:6
                                                numberOfRecepticles:5];
    _codeSelectionView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.65);
    _codeSelectionView.delegate = self;

    
    _submitButton = [[SOButton alloc] initWithType:SOButtonTypeSubmit];
    _submitButton.delegate = self;
    CGFloat y = (self.view.frame.size.height-(_codeSelectionView.frame.size.height+_codeSelectionView.frame.origin.y))/2;
    y = self.view.frame.size.height-y;
    _submitButton.center = CGPointMake(self.view.frame.size.width/2, y);
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

- (void)submitButtonPressed:(SOButton *)submitButton
{
    if ([self.delegate respondsToSelector:@selector(chooseCodeViewController:didReturnCode:)])
    {
        [self.delegate chooseCodeViewController:self didReturnCode:[_codeSelectionView colorsInRecepticles]];
    }
}

@end
