//
//  SOSlotView.m
//  SpotOn
//
//  Created by Stuart Lynch on 08/08/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOSlotView.h"
#import <QuartzCore/QuartzCore.h>

#define SOSlotSpace 12
#define SOSlotWidth 48

@implementation SOSlotView

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame numberOfSlots:(int)slots
{
    if ( (self = [super initWithFrame:frame]) != nil)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        CGMutablePathRef path = CGPathCreateMutable();
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        CGPathAddRect(path, nil, rect);
        
        CGFloat totalWidth = SOSlotWidth*slots + SOSlotSpace*(slots-1);
        CGFloat startX = (frame.size.width-totalWidth)/2;
        CGFloat y = (frame.size.height-SOSlotWidth)/2;

        for (int i=0; i<slots; i++)
        {
            CGPathAddEllipseInRect(path, nil, CGRectMake(startX+i*SOSlotSpace+i*SOSlotWidth-1, y, SOSlotWidth, SOSlotWidth));
        }
        
        maskLayer.path = path;
        maskLayer.fillRule = kCAFillRuleEvenOdd;
        CGPathRelease(path);
        
        self.layer.mask = maskLayer;
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end
