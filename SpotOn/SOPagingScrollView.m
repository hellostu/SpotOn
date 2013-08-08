//
//  SOPagingScrollView.m
//  SpotOn
//
//  Created by Stuart Lynch on 13/07/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOPagingScrollView.h"

@interface SOPagingScrollView ()
{
    
}
@end

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

@implementation SOPagingScrollView

- (id)initWithFrame:(CGRect)frame pageWidth:(CGFloat)pageWidth
{
    pageWidth = MIN(pageWidth,frame.size.width);
    if ((self = [super initWithFrame:frame]) != nil)
    {
        self.clipsToBounds = YES;
        
        CGRect scrollViewFrame = CGRectMake(0, 0, pageWidth, frame.size.height);
        _scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
        _scrollView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return self;
}

- (void)dealloc
{
    [_scrollView release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties
//////////////////////////////////////////////////////////////////////////

- (void)setContentSize:(CGSize)contentSize
{
    _scrollView.contentSize = contentSize;
}

- (CGSize)contentSize
{
    return _scrollView.contentSize;
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return _scrollView;
}

@end
