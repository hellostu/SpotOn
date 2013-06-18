//
//  SLSubmitButton.m
//  DotGame
//
//  Created by Stuart Lynch on 15/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOButton.h"
#import "SOCircle.h"

@interface SOButton ()
{
    SOCircle *_normalState;
    SOCircle *_pressedState;
    SOCircle *_hoverState;
    SOCircle *_currentState;
    UIButton *_overlayButton;
}
@end

@implementation SOButton
@dynamic enabled;
//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithType:(SOButtonType)buttonType
{
    if (self = [super initWithFrame:CGRectMake(0,0,54,54)])
    {
        _buttonType = buttonType;
        
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = NO;
        
        _normalState = [[SOCircle alloc] initWithFrame:self.frame];
        _pressedState = [[SOCircle alloc] initWithFrame:self.frame];
        _hoverState = [[SOCircle alloc] initWithFrame:self.frame];
        
        switch (buttonType) {
            case SOButtonTypeSubmit:
            {
                UIImageView *normalImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"submit_check.png"]];
                normalImage.center = CGPointMake(26, 27);
                UIImageView *pressedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"submit_check_active.png"]];
                pressedImage.center = CGPointMake(26, 27);
                
                [_normalState addSubview:normalImage];
                [_pressedState addSubview:pressedImage];
                [_hoverState addSubview:normalImage];
                [normalImage release];
                [pressedImage release];
                
                _normalState.fillColor = nil;
                _normalState.dashedLine = YES;
                _normalState.strokeColor = GREY_COLOR_BTM_RECEPTICLE;
                
                _pressedState.strokeColor = nil;
                _pressedState.fillColor = GREY_COLOR_BTM_RECEPTICLE;
                break;
            }
            case SOButtonTypeNext:
            {
                UIImageView *normalImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next_arrow_active.png"]];
                normalImage.center = CGPointMake(26, 26);
                UIImageView *pressedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next_arrow_pressed.png"]];
                pressedImage.center = CGPointMake(26, 26);
                UIImageView *hoverImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next_arrow_hover.png"]];
                hoverImage.center = CGPointMake(26, 26);
                
                [_normalState addSubview:normalImage];
                [_pressedState addSubview:pressedImage];
                [_hoverState addSubview:hoverImage];
                [normalImage release];
                [pressedImage release];
                [hoverImage release];
                
                _normalState.fillColor = nil;
                _normalState.dashedLine = YES;
                _normalState.strokeColor = YELLOW_COLOR;
                
                _pressedState.fillColor = nil;
                _pressedState.dashedLine = YES;
                _pressedState.strokeColor = [UIColor colorWithRed:55.0f/255.0f green:28.0f/255.0f blue:0.0f alpha:1.0f];
                
                _hoverState.fillColor = nil;
                _hoverState.dashedLine = YES;
                _hoverState.strokeColor = YELLOW_COLOR;
            }
            default:
                break;
        }
        
        _overlayButton = [[UIButton alloc] initWithFrame:self.frame];
        _overlayButton.backgroundColor = [UIColor clearColor];
        [_overlayButton addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
        [_overlayButton addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_overlayButton addTarget:self action:@selector(touchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [_overlayButton addTarget:self action:@selector(touchDragExit) forControlEvents:UIControlEventTouchDragExit];
        [_overlayButton addTarget:self action:@selector(touchDragEnter) forControlEvents:UIControlEventTouchDragEnter];
        
        [self addSubview:_normalState];
        [self addSubview:_overlayButton];
        _currentState = _normalState;
    }
    return self;
}

- (void)dealloc
{
    [_normalState release];
    [_pressedState release];
    [_hoverState release];
    [_overlayButton release];
    [super dealloc];
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
    [_currentState removeFromSuperview];
    [self addSubview:_pressedState];
    _currentState = _pressedState;
    [self bringSubviewToFront:_overlayButton];
}

- (void)touchUpInside
{
    [_currentState removeFromSuperview];
    [self addSubview:_normalState];
    _currentState = _normalState;
    [self bringSubviewToFront:_overlayButton];
    
    if ([self.delegate respondsToSelector:@selector(submitButtonPressed:)])
    {
        [self.delegate submitButtonPressed:self];
    }
}

- (void)touchUpOutside
{
    [_currentState removeFromSuperview];
    [self addSubview:_normalState];
    _currentState = _normalState;
    [self bringSubviewToFront:_overlayButton];
}

- (void)touchDragExit
{
    [_currentState removeFromSuperview];
    [self addSubview:_hoverState];
    _currentState = _hoverState;
    [self bringSubviewToFront:_overlayButton];
}

- (void)touchDragEnter
{
    [_currentState removeFromSuperview];
    [self addSubview:_normalState];
    _currentState = _normalState;
    [self bringSubviewToFront:_overlayButton];
}

@end
