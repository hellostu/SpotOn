//
//  SLLine.m
//  DotGame
//
//  Created by Stuart Lynch on 14/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOLine.h"

@implementation SOLine

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame
{
    if ( (self = [super initWithFrame:frame]) != nil)
    {
        self.strokeColor = GREY_COLOR_BTM_RECEPTICLE;
        self.dashedLine = NO;
        self.backgroundColor = [UIColor clearColor];
        self.lineType = SOLineTypeHorizontal;
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef color = self.strokeColor.CGColor;
    
    if (self.dashedLine == YES)
    {
        CGFloat dashArray[] = {4,2.1,4,2.1};
        CGContextSetLineDash(context, 3, dashArray, 4);
    }
    CGContextSetStrokeColorWithColor(context, color);
    
    if (self.lineType == SOLineTypeHorizontal)
    {
        CGContextMoveToPoint(context, 0, self.frame.size.height/2);
        CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height/2);
    }
    else if(self.lineType == SOLineTypeVertical)
    {
        CGContextMoveToPoint(context, self.frame.size.width/2, 0);
        CGContextAddLineToPoint(context, self.frame.size.width/2, self.frame.size.height);
    }
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
}

@end
