//
//  SLGuessFeedbackIndicator.m
//  DotGame
//
//  Created by Stuart Lynch on 15/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOGuessFeedbackIndicator.h"
#import "SOCircle.h"

@interface SOGuessFeedbackIndicator ()
{
    NSMutableArray *_indicators; 
}
@end

@implementation SOGuessFeedbackIndicator

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithNumberRecepticles:(int)numberOfRecepticles
{
    CGRect frame = CGRectMake(0,0,28,28);
    if ( (self = [super initWithFrame:frame]) != nil)
    {
        _indicators = [[NSMutableArray alloc] initWithCapacity:numberOfRecepticles];
        
        CGFloat w = 12;
        
        SOCircle *circle1 = [[SOCircle alloc] initWithFrame:CGRectMake(0,  0,  w, w)];
        circle1.fillColor = GREY_COLOR_TOP_INCORRECT;
        SOCircle *circle2 = [[SOCircle alloc] initWithFrame:CGRectMake(frame.size.width-w, 0,  w, w)];
        circle2.fillColor = GREY_COLOR_TOP_INCORRECT;
        SOCircle *circle3 = [[SOCircle alloc] initWithFrame:CGRectMake(0,  frame.size.width-w, w, w)];
        circle3.fillColor = GREY_COLOR_TOP_INCORRECT;
        SOCircle *circle4 = [[SOCircle alloc] initWithFrame:CGRectMake(frame.size.width-w, frame.size.width-w, w, w)];
        circle4.fillColor = GREY_COLOR_TOP_INCORRECT;
        
        [_indicators addObject:circle1];
        [_indicators addObject:circle2];
        [_indicators addObject:circle3];
        [_indicators addObject:circle4];
        
        [circle1 release];
        [circle2 release];
        [circle3 release];
        [circle4 release];
        
        if (numberOfRecepticles>4)
        {
            SOCircle *circle5 = [[SOCircle alloc] initWithFrame:CGRectMake(0, 0, w, w)];
            circle5.fillColor = GREY_COLOR_TOP_INCORRECT;
            circle5.center = CGPointMake(frame.size.width/2, frame.size.height/2);
            
            [_indicators insertObject:circle5 atIndex:2];
            [circle5 release];
        }
        
        for (SOCircle *circle in _indicators)
        {
            [self addSubview:circle];
        }
    }
    return self;
}

- (void)dealloc
{
    [_indicators release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (void)setRightColorRightPosition:(int)rightColorRightPosition andRightColorWrongPosition:(int)rightColorWrongPosition
{
    for (SOCircle *circle in _indicators)
    {
        circle.fillColor = GREY_COLOR_TOP_INCORRECT;
        circle.strokeColor = nil;
        [circle setNeedsDisplay];
    }
    
    for (int i=0; i<rightColorWrongPosition; i++)
    {
        SOCircle *circle = _indicators[i];
        circle.fillColor = nil;
        circle.strokeColor = GREY_COLOR_TOP_CORRECT;
        [circle setNeedsDisplay];
    }
    for (int i=0; i<rightColorRightPosition; i++)
    {
        SOCircle *circle = _indicators[i+rightColorWrongPosition];
        circle.fillColor = GREY_COLOR_TOP_CORRECT;
        circle.strokeColor = nil;
        [circle setNeedsDisplay];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
