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
    
    SOCircle *_fillCircle;
    
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
    CGRect frame = CGRectMake(0, 0, 54, 54);
    if (buttonType == SOButtonTypeText)
    {
        frame = CGRectMake(0, 0, 61, 61);
    }
    if (self = [super initWithFrame:frame])
    {
        _buttonType = buttonType;
        
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = NO;
        
        _normalState = [[SOCircle alloc] initWithFrame:self.frame];
        _pressedState = [[SOCircle alloc] initWithFrame:self.frame];
        _hoverState = [[SOCircle alloc] initWithFrame:self.frame];
        _fillCircle = nil;
        
        switch (buttonType) {
            case SOButtonTypeSubmit:
            {
                UIImageView *normalImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"submit_check.png"]];
                normalImage.center = CGPointMake(26+SO_TOUCH_AREA_INCREASE, 27+SO_TOUCH_AREA_INCREASE);
                UIImageView *pressedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"submit_check_active.png"]];
                pressedImage.center = CGPointMake(26+SO_TOUCH_AREA_INCREASE, 27+SO_TOUCH_AREA_INCREASE);
                UIImageView *hoverImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"submit_check.png"]];
                hoverImage.center = CGPointMake(26+SO_TOUCH_AREA_INCREASE, 27+SO_TOUCH_AREA_INCREASE);
                
                [_normalState addSubview:normalImage];
                [_pressedState addSubview:pressedImage];
                [_hoverState addSubview:hoverImage];
                [normalImage release];
                [pressedImage release];
                [hoverImage release];
                
                _normalState.fillColor = nil;
                _normalState.dashedLine = YES;
                _normalState.strokeColor = GREY_COLOR_BTM_RECEPTICLE;
                
                _hoverState.fillColor = nil;
                _hoverState.dashedLine = YES;
                _hoverState.strokeColor = GREY_COLOR_BTM_RECEPTICLE;
                
                _pressedState.strokeColor = nil;
                _pressedState.fillColor = GREY_COLOR_BTM_RECEPTICLE;
                break;
            }
            case SOButtonTypeBack:
            {
                UIImageView *normalImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_arrow.png"]];
                normalImage.center = CGPointMake(25+SO_TOUCH_AREA_INCREASE, 26+SO_TOUCH_AREA_INCREASE);
                UIImageView *pressedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_arrow_active.png"]];
                pressedImage.center = CGPointMake(25+SO_TOUCH_AREA_INCREASE, 26+SO_TOUCH_AREA_INCREASE);
                UIImageView *hoverImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_arrow.png"]];
                hoverImage.center = CGPointMake(25+SO_TOUCH_AREA_INCREASE, 26+SO_TOUCH_AREA_INCREASE);
                
                [_normalState addSubview:normalImage];
                [_pressedState addSubview:pressedImage];
                [_hoverState addSubview:hoverImage];
                [normalImage release];
                [pressedImage release];
                [hoverImage release];
                
                _normalState.fillColor = nil;
                _normalState.dashedLine = YES;
                _normalState.strokeColor = GREY_COLOR_BTM_RECEPTICLE;
                
                _hoverState.fillColor = nil;
                _hoverState.dashedLine = YES;
                _hoverState.strokeColor = GREY_COLOR_BTM_RECEPTICLE;
                
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
                _normalState.strokeColor = ORANGE_COLOR;
                
                _pressedState.fillColor = nil;
                _pressedState.dashedLine = YES;
                _pressedState.strokeColor = [UIColor colorWithRed:55.0f/255.0f green:28.0f/255.0f blue:0.0f alpha:1.0f];
                
                _hoverState.fillColor = nil;
                _hoverState.dashedLine = YES;
                _hoverState.strokeColor = ORANGE_COLOR;
            }
            case SOButtonTypeText:
            {
                _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _normalState.frame.size.width-1, _normalState.frame.size.height-1)];
                _titleLabel.backgroundColor = [UIColor clearColor];
                _titleLabel.font = [UIFont fontWithName:@"GothamHTF-Medium" size:15.0f];
                _titleLabel.textColor = GREY_COLOR_BTM_RECEPTICLE;
                _titleLabel.textAlignment = NSTextAlignmentCenter;
                
                _pressedTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _normalState.frame.size.width-1, _normalState.frame.size.height-1)];
                _pressedTitleLabel.backgroundColor = [UIColor clearColor];
                _pressedTitleLabel.font = [UIFont fontWithName:@"GothamHTF-Medium" size:15.0f];
                _pressedTitleLabel.textColor = GREY_COLOR_BTM_BACKGROUND;
                _pressedTitleLabel.textAlignment = NSTextAlignmentCenter;
                
                _hoverTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _normalState.frame.size.width-1, _normalState.frame.size.height-1)];
                _hoverTitleLabel.backgroundColor = [UIColor clearColor];
                _hoverTitleLabel.font = [UIFont fontWithName:@"GothamHTF-Medium" size:15.0f];
                _hoverTitleLabel.textColor = GREY_COLOR_BTM_RECEPTICLE;
                _hoverTitleLabel.textAlignment = NSTextAlignmentCenter;
                
            }
            case SOButtonTypeDefault:
            {
                _normalState.fillColor = nil;
                _normalState.dashedLine = YES;
                _normalState.strokeColor = GREY_COLOR_BTM_RECEPTICLE;
                
                _hoverState.fillColor = nil;
                _hoverState.dashedLine = YES;
                _hoverState.strokeColor = GREY_COLOR_BTM_RECEPTICLE;
                
                _pressedState.fillColor = nil;
                _pressedState.dashedLine = YES;
                _pressedState.strokeColor = GREY_COLOR_BTM_RECEPTICLE;
                
                _fillCircle = [[SOCircle alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.88, self.frame.size.height*0.88)];
                _fillCircle.center = CGPointMake(_pressedState.frame.size.width/2, _pressedState.frame.size.height/2);
                [_pressedState addSubview:_fillCircle];
                
                int rand = arc4random()%6;
                self.fillColor = [SOCircle colorForTag:rand];
                
                [_normalState addSubview:_titleLabel];
                [_pressedState addSubview:_pressedTitleLabel];
                [_hoverState addSubview:_hoverTitleLabel];
                
                break;
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
    [_fillCircle release];
    [_titleLabel release];
    [_pressedTitleLabel release];
    [_hoverTitleLabel release];
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

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = [fillColor retain];
    _fillCircle.fillColor = fillColor;
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
    
    if ([self.delegate respondsToSelector:@selector(buttonPressed:)])
    {
        [self.delegate buttonPressed:self];
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
