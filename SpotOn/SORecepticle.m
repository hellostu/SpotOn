//
//  SLCircleSlot.m
//  DotGame
//
//  Created by Stuart Lynch on 13/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SORecepticle.h"

@implementation SORecepticle

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame
{
    if ( (self = self = [super initWithFrame:frame]) != nil)
    {
        self.fillColor = nil;
        self.strokeColor = GREY_COLOR_BTM_RECEPTICLE;
        self.dashedLine = YES;
        _circle = nil;
    }
    return self;
}

- (void)dealloc
{
    [_circle release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
