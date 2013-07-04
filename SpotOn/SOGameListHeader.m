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

@end
