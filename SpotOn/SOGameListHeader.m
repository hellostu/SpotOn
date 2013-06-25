//
//  SOGameListHeader.m
//  SpotOn
//
//  Created by Stuart Lynch on 23/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOGameListHeader.h"

@implementation SOGameListHeader

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame
{
    if ( (self = [super initWithFrame:frame]) != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _textLabel.backgroundColor = GREY_COLOR_BTM_BACKGROUND;
        _textLabel.textColor = GREY_COLOR_TOP_TEXT_LIGHT;
        _textLabel.font = [UIFont fontWithName:@"GothamHTF-Medium" size:15];
        _textLabel.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)dealloc
{
    [_textLabel release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Drawing
//////////////////////////////////////////////////////////////////////////

- (void)drawLinearGradientWithContext:(CGContextRef)context inRect:(CGRect)rect startColor:(CGColorRef)startColor endColor:(CGColorRef)endColor
{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                        (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef startColor = GREY_COLOR_BTM_BACKGROUND.CGColor;
    CGColorRef endColor = [UIColor clearColor].CGColor;
    CGRect paperRect = self.frame;
    [self drawLinearGradientWithContext:context
                                            inRect:paperRect
                                        startColor:startColor
                                          endColor:endColor];
    [super drawRect:rect];
}

@end
