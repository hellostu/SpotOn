//
//  SLPreviousGuessView.m
//  DotGame
//
//  Created by Stuart Lynch on 14/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOPreviousGuessView.h"
#import "SOCircle.h"

@interface SOPreviousGuessView ()
{
    NSMutableArray  *_guess;
}
@end

@implementation SOPreviousGuessView

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame numberOfColors:(int)numberOfCircles
{
    if ( (self = self = [super initWithFrame:frame]) != nil)
    {
        _guess = [[NSMutableArray alloc] initWithCapacity:numberOfCircles];
        for (int i=0; i<numberOfCircles; i++)
        {
            SOCircle *circle = [[SOCircle alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
            circle.draggable = NO;
            circle.center = CGPointMake(i*30+55, frame.size.height/2);
            circle.fillColor = GREY_COLOR_TOP_CORRECT;
            [self addSubview:circle];
            [_guess addObject:circle];
            [circle release];
        }
        
        _guessFeedbackIndicator = [[SOGuessFeedbackIndicator alloc] initWithNumberRecepticles:numberOfCircles];
        _guessFeedbackIndicator.center = CGPointMake(frame.size.width-55, frame.size.height/2);
        [self addSubview:_guessFeedbackIndicator];
        
        _colors = nil;
        
    }
    return self;
}

- (void)dealloc
{
    [_colors release];
    [_guess release];
    [_guessFeedbackIndicator release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (void)setRightColorRightPosition:(int)rightColorRightPosition andRightColorWrongPosition:(int)rightColorWrongPosition animated:(BOOL)animated
{
    if (animated == YES)
    {
        [UIView animateWithDuration:0.4 animations:^(){
            _guessFeedbackIndicator.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [_guessFeedbackIndicator setRightColorRightPosition:rightColorRightPosition
                                     andRightColorWrongPosition:0];
            [UIView animateWithDuration:0.4 animations:^(){
                _guessFeedbackIndicator.alpha = 1.0f;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 animations:^() {
                    _guessFeedbackIndicator.alpha = 0.0f;
                } completion:^(BOOL finished) {
                        [_guessFeedbackIndicator setRightColorRightPosition:rightColorRightPosition
                                                 andRightColorWrongPosition:rightColorWrongPosition];
                        [UIView animateWithDuration:0.4 animations:^(){
                            _guessFeedbackIndicator.alpha = 1.0f;
                        }];
                }];
            }];
        }];
    }
    else
    {
        [_guessFeedbackIndicator setRightColorRightPosition:rightColorRightPosition
                                 andRightColorWrongPosition:rightColorWrongPosition];
    }
    
}

- (void)updateWithColors:(NSArray *)colors
{
    _colors = [colors retain];
    for (int i=0; i<_guess.count; i++)
    {
        SOCircle *circle = _guess[i];
        circle.fillColor = [SOCircle colorForTag:((NSNumber *)colors[i]).intValue];
        [circle setNeedsDisplay];
    }
}

- (void)clearColors
{
    for (SOCircle *circle in _guess)
    {
        circle.fillColor = GREY_COLOR_TOP_CORRECT;
    }
}

@end
