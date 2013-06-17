//
//  SLCodeSelectionView.m
//  DotGame
//
//  Created by Stuart Lynch on 14/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOCodeSelectionView.h"
#import "SOCircle.h"
#import "SORecepticle.h"
#import <QuartzCore/QuartzCore.h>

@interface SOCodeSelectionView () <SLCircleDelegate>
{
    NSMutableArray *_recepticles;
    NSMutableArray *_palette;
    BOOL            _animating;
}
@end

@implementation SOCodeSelectionView

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame numberOfColors:(int)numberOfColors numberOfRecepticles:(int)numberOfRecepticles
{
    if ((self = [super initWithFrame:frame]) != nil)
    {
        _recepticles = [[NSMutableArray alloc] initWithCapacity:numberOfColors];
        _palette = [[NSMutableArray alloc] initWithCapacity:numberOfColors];
        
        CGFloat interval = 30;
        
        for (int i=0; i<numberOfRecepticles; i++)
        {
            SORecepticle *recepticle = [[SORecepticle alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            recepticle.center = CGPointMake(i*interval+25, 30);
            [self addSubview:recepticle];
            [_recepticles addObject:recepticle];
            [recepticle release];
        }
        
        for (int i=0; i<numberOfColors; i++)
        {
            SOCircle *paletteCircle = [[SOCircle alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            
            paletteCircle.center = CGPointMake(i*interval+25, self.frame.size.height-30);
            paletteCircle.startLocation = paletteCircle.center;
            paletteCircle.draggable = YES;
            paletteCircle.delegate = self;
            paletteCircle.tag = i;
            
            [_palette addObject:paletteCircle];
            [self addSubview:paletteCircle];
            
            paletteCircle.tag = i;
            paletteCircle.fillColor = [SOCircle colorForTag:i];
            
            
            [paletteCircle release];
        }
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SLCircleDelegate
//////////////////////////////////////////////////////////////////////////

- (void)circle:(SOCircle *)circle beganDragAtLocation:(CGPoint)location
{
    [self moveCircleToTop:circle];
    circle.center = location;
}

- (void)circle:(SOCircle *)circle wasDraggedAtLocation:(CGPoint)location
{
    circle.center = location;
}

- (void)circle:(SOCircle *)circle endedDragAtLocation:(CGPoint)location
{
    int index = [circle indexOfRecepticleWithCollisionFromRecepticles:_recepticles];
    if (index >= 0)
    {
        SORecepticle *recepticle = _recepticles[index];
        [self moveCircle:circle toRecepticle:recepticle];
    }
    else if(circle.recepticle != nil)
    {
        [self removeCircle:circle];
    }
    else
    {
        [self moveCircleToStart:circle];
    }
}

- (void)circleWasTapped:(SOCircle *)circle
{
    if (circle.recepticle != nil)
    {
        [self removeCircle:circle];
    }
    else
    {
        SORecepticle *recepticle = [self firstFreeRecepticle];
        if (recepticle != nil)
        {
            [self moveCircle:circle toRecepticle:recepticle];
        }
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (BOOL)recepticlesPopulated
{
    for (SORecepticle *recepticle in _recepticles)
    {
        if(recepticle.circle == nil)
        {
            return NO;
        }
    }
    return YES;
}

- (NSArray *)colorsInRecepticles
{
    NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:_recepticles.count];
    for (SORecepticle *recepticle in _recepticles)
    {
        [colors addObject:@(recepticle.circle.tag)];
    }
    return [colors autorelease];
}

- (void)copyCircle:(SOCircle *)circle intoRecepticle:(SORecepticle *)recepticle
{
    SOCircle *circleCopy = [circle copy];
    circleCopy.center = recepticle.center;
    if (recepticle.circle != nil)
    {
        [recepticle.circle removeFromSuperview];
    }
    recepticle.circle = circleCopy;
    circleCopy.recepticle = recepticle;
    [self addSubview:circleCopy];
    [circleCopy release];
}

- (SORecepticle *)firstFreeRecepticle
{
    for (SORecepticle *recepticle in _recepticles)
    {
        if (recepticle.circle == nil)
        {
            return recepticle;
        }
    }
    return  nil;
}

- (void)moveCircleToTop:(SOCircle *)circle
{
    [self bringSubviewToFront:circle];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Animations
//////////////////////////////////////////////////////////////////////////

- (void)submitAllCirclesWithCompletion:(void (^)(NSArray *circles))completion
{
    NSArray *colors = [self colorsInRecepticles];
    
    if ([self recepticlesPopulated] == YES)
    {
        void (^completionHandler)(BOOL finished) = nil;
        
        for (int i=0; i<_recepticles.count; i++)
        {
            if (i>=(_recepticles.count-1))
            {
                completionHandler = ^(BOOL finished) {
                    if (completion != nil)
                    {
                        completion(colors);
                    }
                    for (int i=0; i<_recepticles.count; i++)
                    {
                        SOCircle *circle = ((SORecepticle *)_recepticles[i]).circle;
                        ((SORecepticle *)_recepticles[i]).circle = nil;
                        [circle removeFromSuperview];
                    }
                };
            }
            
            SOCircle *circle = ((SORecepticle *)_recepticles[i]).circle;
            CGFloat index = (CGFloat)i;
            index/=(CGFloat)(_recepticles.count-1);
            index*=0.3;
            
            
            [UIView animateWithDuration:0.5-index delay:index options:0 animations:^(){
                CGFloat y = -38;
                if(self.window.frame.size.height > 500)
                {
                    y = -76;
                }
                
                circle.layer.affineTransform = CGAffineTransformMakeScale(0.5, 0.5);
                circle.center = CGPointMake(i*30+30, y);
            }completion:completionHandler];
        }
    }
}

- (void)moveCircle:(SOCircle *)circle toRecepticle:(SORecepticle *)recepticle
{
    if (recepticle.circle == nil)
    {
        SOCircle *placeHolderCircle = [[SOCircle alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        placeHolderCircle.placeholder = YES;
        recepticle.circle = placeHolderCircle;
        placeHolderCircle.recepticle = recepticle;
        [placeHolderCircle release];
    }
    
    if (circle.recepticle != recepticle) 
    {
        if ([self.delegate respondsToSelector:@selector(codeSelectionViewWillChangeRecepticles:)])
        {
            [self.delegate codeSelectionViewWillChangeRecepticles:self];
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^() {
        circle.center = recepticle.center;
    } completion:^(BOOL finished) {
        if (circle.recepticle != recepticle) //Don't do anything if moving to self
        {
            if (recepticle.circle != nil && recepticle.circle.placeholder == NO)
            {
                [recepticle.circle removeFromSuperview];
                recepticle.circle = nil;
            }
            if (circle.recepticle == nil)
            {
                [self regrowCircle:circle];
                [self copyCircle:circle intoRecepticle:recepticle];
            }
            else
            {
                circle.recepticle.circle = nil;
                recepticle.circle = circle;
                circle.recepticle = recepticle;
            }
        }
    }];
}

- (void)moveCircleToStart:(SOCircle *)circle
{
    _animating = YES;
    [UIView animateWithDuration:0.2 animations:^() {
        circle.center = circle.startLocation;
    } completion:^(BOOL finished) {
        _animating = NO;
    }];
}

- (void)removeCircle:(SOCircle *)circle
{
    _animating = YES;
    [UIView animateWithDuration:0.2 animations:^() {
        circle.layer.affineTransform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [circle removeFromSuperview];
        circle.recepticle.circle = nil;
        circle.recepticle = nil;
        _animating = NO;
        if ([self.delegate respondsToSelector:@selector(codeSelectionViewWillChangeRecepticles:)] == YES)
        {
            [self.delegate codeSelectionViewWillChangeRecepticles:self];
        }
    }];
}

- (void)regrowCircle:(SOCircle *)circle
{
    _animating = YES;
    circle.center = circle.startLocation;
    circle.layer.affineTransform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.2 animations:^() {
        circle.layer.affineTransform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        _animating = NO;
    }];
}

@end
