//
//  SLPreviousGuessesView.m
//  DotGame
//
//  Created by Stuart Lynch on 14/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOPreviousGuessesView.h"
#import "SOPreviousGuessView.h"

@interface SOPreviousGuessesView ()
{
    NSMutableArray  *_guesses;
    UIView          *_guessWrapperView;
}
@end

#define GUESS_VIEW_HEIGHT 37
#define NUMBER_OF_TURNS 12

@implementation SOPreviousGuessesView

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame
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

- (void)forLastTurnSetRightColorRightPosition:(int)rightColorRightPosition andRightColorWrongPosition:(int)rightColorWrongPosition
{
    SOPreviousGuessView *previousGuess = _guesses[_turnsTaken];
    [previousGuess setRightColorRightPosition:rightColorRightPosition andRightColorWrongPosition:rightColorWrongPosition];
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
    SOPreviousGuessView *previousGuessView = _guesses[_turnsTaken];
    [previousGuessView updateWithColors:colors];
    _turnsTaken++;
}

- (void)addNewRow
{
    if (self.turnsTaken <= _guesses.count)
    {
        CGFloat y = GUESS_VIEW_HEIGHT*(self.turnsTaken)+15;
        SOPreviousGuessView *previousGuess = [[SOPreviousGuessView alloc] initWithFrame:CGRectMake(0, y, self.frame.size.width, 20) numberOfColors:5 index:0];
        [_guessWrapperView addSubview:previousGuess];
        [_guesses addObject:previousGuess];
        
        previousGuess.alpha = 0.0f;
        [UIView animateWithDuration:0.2 animations:^() {
            previousGuess.alpha = 1.0f;
            [self updateGuessWrapperViewLocationAndSize];
            [self updateContentSize];
            [self scrollToEndAnimated:NO withCompletion:nil];
        }];
    }
}


@end
