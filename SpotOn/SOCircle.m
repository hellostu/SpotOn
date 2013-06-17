//
//  SLCircle.m
//  Mastermind
//
//  Created by Stuart Lynch on 13/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOCircle.h"
#import "SORecepticle.h"

#import <QuartzCore/QuartzCore.h>

@interface SOCircle ()
{
    UIPanGestureRecognizer *_panGesture;
    UITapGestureRecognizer *_tapGesture;
}

@end

@implementation SOCircle

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)copyWithZone:(NSZone *)zone
{
    SOCircle *circle = [[SOCircle alloc] initWithFrame:self.frame];
    circle.fillColor = self.fillColor;
    circle.strokeColor = self.strokeColor;
    circle.startLocation = self.startLocation;
    circle.draggable = self.draggable;
    circle.delegate = self.delegate;
    circle.tag = self.tag;
    return circle;
}

- (id)initWithFrame:(CGRect)frame
{
    if ( (self = self = [super initWithFrame:frame]) != nil)
    {
        self.fillColor = [UIColor blueColor];
        self.backgroundColor = [UIColor clearColor];
        self.recepticle = nil;
        
        _startLocation = CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
        
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circlePannedWithGesture:)];
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(circleTappedWithGesture:)];
    }
    return self;
}

- (void)dealloc
{
    [_fillColor release];
    [_strokeColor release];
    [_panGesture release];
    [_tapGesture release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect circleRect = CGRectMake(1, 1, self.frame.size.width-4, self.frame.size.height-4);
    CGContextAddEllipseInRect(context, circleRect);
    if (self.fillColor != nil)
    {
        CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
        CGContextFillPath(context);
    }
    if (self.strokeColor != nil)
    {
        if (self.dashedLine == YES)
        {
            CGFloat dashArray[] = {4,2,4,2};
            CGContextSetLineDash(context, 3, dashArray, 4);
        }
        circleRect = CGRectMake(1.5, 1.5, self.frame.size.width-5, self.frame.size.height-5);
        CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
        CGContextSetLineWidth(context, 1.0);
        CGContextStrokeEllipseInRect(context, circleRect);
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Overwridden
//////////////////////////////////////////////////////////////////////////

- (void)setDraggable:(BOOL)draggable
{
    if (draggable == YES)
    {
        [self addGestureRecognizer:_panGesture];
        [self addGestureRecognizer:_tapGesture];
    }
    else
    {
        [self removeGestureRecognizer:_panGesture];
        [self removeGestureRecognizer:_tapGesture];
    }
    _draggable = draggable;
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions
//////////////////////////////////////////////////////////////////////////

- (void)circleTappedWithGesture:(UITapGestureRecognizer *)tapGesture
{
    if ([self.delegate respondsToSelector:@selector(circleWasTapped:)])
    {
        [self.delegate circleWasTapped:self];
    }
}

- (void)circlePannedWithGesture:(UIPanGestureRecognizer *)panGesture
{
    if (self.draggable == YES)
    {
        CGPoint location = [panGesture locationInView:self.superview];
        switch(panGesture.state)
        {
            case UIGestureRecognizerStateBegan:
            {
                if ([self.delegate respondsToSelector:@selector(circle:beganDragAtLocation:)])
                {
                    [self.delegate circle:self beganDragAtLocation:location];
                }
                break;
            }
            case UIGestureRecognizerStateChanged:
            {
                if ([self.delegate respondsToSelector:@selector(circle:wasDraggedAtLocation:)])
                {
                    [self.delegate circle:self wasDraggedAtLocation:location];
                }
                break;
            }
            case UIGestureRecognizerStateEnded:
            {
                
                if ([self.delegate respondsToSelector:@selector(circle:endedDragAtLocation:)])
                {
                    [self.delegate circle:self endedDragAtLocation:location];
                }
                break;
            }
            default:
            {
                break;
            }
        }
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

+ (UIColor *)colorForTag:(SOCircleColor)tag
{
    switch (tag)
    {
        case SOCircleColorRed:
        {
            return RED_COLOR;
            break;
        }
        case SOCircleColorBrown:
        {
            return BROWN_COLOR;
            break;
        }
        case SOCircleColorBlue:
        {
            return BLUE_COLOR;
            break;
        }
        case SOCircleColorYellow:
        {
            return YELLOW_COLOR;
            break;
        }
        case SOCircleColorGreen:
        {
            return GREEN_COLOR;
            break;
        }
        case SOCircleColorPurple:
        {
            return PURPLE_COLOR;
            break;
        }
        default:
        {
            return nil;
            break;
        }
    }
}

- (int)indexOfRecepticleWithCollisionFromRecepticles:(NSArray *)recepticles
{
    int index = -1;
    if (recepticles != nil)
    {
        CGFloat minMag = 100000;
        
        for (int i=0; i<recepticles.count; i++)
        {
            if ([recepticles[i] isKindOfClass:SORecepticle.class] == YES)
            {
                SORecepticle *recepticle = recepticles[i];
                
                CGPoint dist = CGPointMake(recepticle.center.x-self.center.x, recepticle.center.y-self.center.y);
                CGFloat mag = dist.x*dist.x+dist.y*dist.y;
                CGFloat minRadius = MIN(self.frame.size.width, recepticle.frame.size.width);
                minRadius*=2;
                
                if (mag < minRadius*minRadius & mag< minMag)
                {
                    minMag = mag;
                    index = i;
                }
            }
        }
    }
    return index;
}

@end
