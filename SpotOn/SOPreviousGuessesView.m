//
//  SLPreviousGuessesView.m
//  DotGame
//
//  Created by Stuart Lynch on 14/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOPreviousGuessesView.h"
#import "SOPreviousGuessView.h"
#import "SOCircle.h"

@interface SOPreviousGuessesView ()
{
    NSMutableArray  *_guesses;
    UIView          *_guessWrapperView;
    
    int             _numberOfRecepticles;
}
@end

#define GUESS_VIEW_HEIGHT 50
#define NUMBER_OF_TURNS 12

@implementation SOPreviousGuessesView

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame numberOfRecepticles:(int)numberOfRecepticles
{
    if ((self = [super initWithFrame:frame]) != nil)
    {
        _guesses = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_TURNS];
        self.backgroundColor = GREY_COLOR_TOP_BACKGROUND;
        
        _guessWrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-GUESS_VIEW_HEIGHT, self.frame.size.width, GUESS_VIEW_HEIGHT+15)];
        [self updateGuessWrapperViewLocationAndSize];
        [self updateContentSize];
        
        [self addSubview:_guessWrapperView];
        _turnsTaken = 0;
        
        _numberOfRecepticles = numberOfRecepticles;
    }
    return self;
}

- (void)dealloc
{
    [_guesses release];
    [_guessWrapperView release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (int)numberOfGuesses
{
    return _guesses.count;
}

- (BOOL)hasWon
{
    if (_guesses.count > 0)
    {
        SOPreviousGuessView *previousGuessView = [_guesses lastObject];
        if (previousGuessView.guessFeedbackIndicator.rightColorRightPosition == previousGuessView.colors.count)
        {
            return YES;
        }
    }
    return NO;
}

- (void)updateFeedbackIndicatorsWithOpponentsCode:(NSArray *)opponentsCode animated:(BOOL)animated completion:(void (^)(void))handler
{
    if (_guesses.count > 0)
    {
        for (SOPreviousGuessView *guessView in _guesses)
        {
            if(guessView.guessFeedbackIndicator.upToDate == NO && guessView.colors != nil)
            {
                NSDictionary *result = [self provideFeedbackForGuess:guessView.colors withOpponentsCode:opponentsCode];
                int rightColorWrongPosition = ((NSNumber *)result[@"Right Color Wrong Position"]).intValue;
                int rightColorRightPosition = ((NSNumber *)result[@"Right Color Right Position"]).intValue;
                
                [guessView setRightColorRightPosition:rightColorRightPosition andRightColorWrongPosition:rightColorWrongPosition animated:animated withCompletionHandler:handler];
            }
        }
    }
}

- (NSDictionary *)provideFeedbackForGuess:(NSArray *)guess withOpponentsCode:(NSArray *)opponentsCode
{
    int rightColorRightPosition = 0;
    int rightColorWrongPosition = 0;
    for (int i=0; i<guess.count; i++)
    {
        SOCircleColor thisColor = (SOCircleColor)((NSNumber *)opponentsCode[i]).intValue;
        SOCircleColor thatColor = (SOCircleColor)((NSNumber *)guess[i]).intValue;
        
        if (thisColor == thatColor)
        {
            rightColorRightPosition++;
        }
        
    }
    
    NSArray *thisMap = [SOCircle mapFromColors:opponentsCode];
    NSArray *thatMap = [SOCircle mapFromColors:guess];
    
    for (int i=0; i<thisMap.count; i++)
    {
        rightColorWrongPosition += MIN(((NSNumber *)thisMap[i]).intValue,((NSNumber *)thatMap[i]).intValue);
    }
    rightColorWrongPosition-=rightColorRightPosition;
    
    return @{@"Right Color Wrong Position" : @(rightColorWrongPosition), @"Right Color Right Position" : @(rightColorRightPosition)};
}

- (void)updateWithGuesses:(NSArray *)guesses
{
    if (_guesses.count == 0)
    {
        for (NSArray *colorCode in guesses)
        {
            [self addNewRowAnimated:NO];
            SOPreviousGuessView *guessView = [_guesses lastObject];
            [guessView updateWithColors:colorCode];
            _turnsTaken++;
        }
        _turnsTaken = _guesses.count;
    }
}

- (NSArray *)guessesList
{
    NSMutableArray *guessesList = [[NSMutableArray alloc] initWithCapacity:_guesses.count];
    for (SOPreviousGuessView *previousGuess in _guesses)
    {
        if (previousGuess.colors != nil)
        {
            [guessesList addObject:previousGuess.colors];
        }
    }
    return [guessesList autorelease];
}

- (void)updateGuessWrapperViewLocationAndSize
{
    CGFloat y = MAX(self.frame.size.height-GUESS_VIEW_HEIGHT*(self.turnsTaken+1)-15,0);
    CGRect frame = CGRectMake(0, y, self.frame.size.width, GUESS_VIEW_HEIGHT*(self.turnsTaken+1)+15);
    _guessWrapperView.frame = frame;
}

- (void)updateContentSize
{
    CGFloat y = MAX(_guessWrapperView.frame.size.height,self.frame.size.height);
    self.contentSize = CGSizeMake(self.frame.size.width, y);
}

- (void)scrollToEndAnimated:(BOOL)animated withCompletion:(void (^)(void))completion
{
    if (animated == YES)
    {
        [UIView animateWithDuration:0.2 animations:^() {
            self.contentOffset = CGPointMake(0, self.contentSize.height-self.frame.size.height);
        }completion:^(BOOL finished) {
            if (completion != nil)
            {
                completion();
            }
        }];
    }
    else
    {
        self.contentOffset = CGPointMake(0, self.contentSize.height-self.frame.size.height);
        if (completion != nil)
        {
            completion();
        }
    }
}

- (void)scrollToTurnWithCompleition:(void (^)(void))completion
{
    [UIView animateWithDuration:0.2 animations:^() {
        self.contentOffset = CGPointMake(0, self.turnsTaken*GUESS_VIEW_HEIGHT);
    }completion:^(BOOL finished) {
        if (completion != nil)
        {
            completion();
        }
    }];
    
}

- (void)takeTurnWithColors:(NSArray *)colors
{
    NSLog(@"Colors: %@", colors);
    SOPreviousGuessView *previousGuessView = _guesses[_turnsTaken];
    [previousGuessView updateWithColors:colors];
    _turnsTaken++;
}

- (void)addNewRowAnimated:(BOOL)animated
{
    
    if (self.turnsTaken == _guesses.count)
    {
        CGFloat y = GUESS_VIEW_HEIGHT*(self.turnsTaken)+15;
        SOPreviousGuessView *previousGuess = [[SOPreviousGuessView alloc] initWithFrame:CGRectMake(0, y, self.frame.size.width, 20) numberOfColors:_numberOfRecepticles];
        [_guessWrapperView addSubview:previousGuess];
        [_guesses addObject:previousGuess];
        
        if (animated == YES)
        {
            previousGuess.alpha = 0.0f;
            [UIView animateWithDuration:0.2 animations:^() {
                previousGuess.alpha = 1.0f;
                [self updateGuessWrapperViewLocationAndSize];
                [self updateContentSize];
                [self scrollToEndAnimated:NO withCompletion:nil];
            }];
        }
        else
        {
            [self updateGuessWrapperViewLocationAndSize];
            [self updateContentSize];
            [self scrollToEndAnimated:NO withCompletion:nil];
        }
        [previousGuess release];
    }
}


@end
