//
//  SLLine.m
//  DotGame
//
//  Created by Stuart Lynch on 14/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOLine.h"

@implementation SOLine

- (id)initWithFrame:(CGRect)frame
{
    if ( (self = [super initWithFrame:frame]) != nil)
    {
        self.strokeColor = GREY_COLOR_BTM_RECEPTICLE;
        self.dashedLine = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef color = self.strokeColor.CGColor;
    
    if (self.dashedLine == YES)
    {
        CGFloat dashArray[] = {4,4,4,4};
        CGContextSetLineDash(context, 3, dashArray, 4);
    }
    CGContextSetStrokeColorWithColor(context, color);
    
    CGContextMoveToPoint(context, 0, self.frame.size.height/2);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height/2);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
}

@end
