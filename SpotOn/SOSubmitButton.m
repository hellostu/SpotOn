//
//  SLSubmitButton.m
//  DotGame
//
//  Created by Stuart Lynch on 15/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOSubmitButton.h"
#import "SOCircle.h"

@interface SOSubmitButton ()
{
    SOCircle *_normalState;
    SOCircle *_pressedState;
    SOCircle *_activeState;
    UIButton *_overlayButton;
}
@end

@implementation SOSubmitButton
@dynamic enabled;
//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)init
{
    if (self = [super initWithFrame:CGRectMake(0,0,54,54)])
    {
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = NO;
        
        _normalState = [[SOCircle alloc] initWithFrame:self.frame];
        _pressedState = [[SOCircle alloc] initWithFrame:self.frame];
        
        UIImageView *normalImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"submit_check.png"]];
        normalImage.center = CGPointMake(26, 27);
        UIImageView *pressedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"submit_check_active.png"]];
        pressedImage.center = CGPointMake(26, 27);
        
        [_normalState addSubview:normalImage];
        [_pressedState addSubview:pressedImage];
        [normalImage release];
        [pressedImage release];
        
        _normalState.fillColor = nil;
        _normalState.dashedLine = YES;
        _normalState.strokeColor = GREY_COLOR_BTM_RECEPTICLE;
        
        _pressedState.strokeColor = nil;
        _pressedState.fillColor = GREY_COLOR_BTM_RECEPTICLE;
        
        _overlayButton = [[UIButton alloc] initWithFrame:self.frame];
        _overlayButton.backgroundColor = [UIColor clearColor];
        [_overlayButton addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
        [_overlayButton addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_overlayButton addTarget:self action:@selector(touchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        
        [self addSubview:_normalState];
        [self addSubview:_overlayButton];
        _activeState = _normalState;
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties
//////////////////////////////////////////////////////////////////////////

- (void)setEnabled:(BOOL)enabled
{
    _overlayButton.enabled = enabled;
}

- (BOOL)enabled
{
    return _overlayButton.enabled;
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions
//////////////////////////////////////////////////////////////////////////


- (void)touchDown
{
    [_activeState removeFromSuperview];
    [self addSubview:_pressedState];
    _activeState = _pressedState;
    [self bringSubviewToFront:_overlayButton];
}

- (void)touchUpInside
{
    [_activeState removeFromSuperview];
    [self addSubview:_normalState];
    _activeState = _normalState;
    [self bringSubviewToFront:_overlayButton];
    
    if ([self.delegate respondsToSelector:@selector(submitButtonPressed:)])
    {
        [self.delegate submitButtonPressed:self];
    }
}

- (void)touchUpOutside
{
    [_activeState removeFromSuperview];
    [self addSubview:_normalState];
    _activeState = _normalState;
    [self bringSubviewToFront:_overlayButton];
}

@end
