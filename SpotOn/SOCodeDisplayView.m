//
//  SOCodeDisplayView.m
//  SpotOn
//
//  Created by Stuart Lynch on 16/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOCodeDisplayView.h"
#import "SORecepticle.h"

@implementation SOCodeDisplayView

- (id)initWithCode:(NSArray *)code
{
    
    CGFloat inset = 39;
    CGFloat interval = 55
    
    ;
    CGRect frame = CGRectMake(0,0,interval*5+inset/2,50);
    
    if ( (self = [super initWithFrame:frame]) != nil)
    {
        
        
        for (int i=0; i<code.count; i++)
        {
            SORecepticle *recepticle = [[SORecepticle alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            recepticle.center = CGPointMake(i*interval+inset, 30);
            [self addSubview:recepticle];
            
            
            SOCircle *paletteCircle = [[SOCircle alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            
            paletteCircle.center = recepticle.center;
            paletteCircle.startLocation = paletteCircle.center;
            paletteCircle.draggable = NO;
            SOCircleColor circleColor = ((NSNumber *)code[i]).intValue;
            paletteCircle.fillColor = [SOCircle colorForTag:circleColor];
            
            [self addSubview:paletteCircle];
            
            paletteCircle.tag = i;
            
            [recepticle release];
            [paletteCircle release];
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
