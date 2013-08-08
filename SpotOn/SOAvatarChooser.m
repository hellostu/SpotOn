//
//  SOAvatarChooser.m
//  SpotOn
//
//  Created by Stuart Lynch on 13/07/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOAvatarChooser.h"
#import "SOProfilePicture.h"

@implementation SOAvatarChooser

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)init
{
    CGRect frame = CGRectMake(0, 0, 320, 92);
    if ((self = [super initWithFrame:frame pageWidth:100]) != nil)
    {
        for (int i=0; i<10; i++)
        {
            SOProfilePicture *avatar = [[SOProfilePicture alloc] initWithType:SOProfilePictureTypeLarge];
            avatar.center = CGPointMake((100*i)+50+0.5, frame.size.height/2+0.5);
            [_scrollView addSubview:avatar];
            
            SOCircle *circle = [[SOCircle alloc] initWithFrame:CGRectMake(0, 0, 92, 92)];
            circle.strokeColor = GREY_COLOR_TOP_TEXT;
            circle.strokeWidth = 3.0f;
            circle.fillColor = nil;
            circle.center = CGPointMake(frame.size.width/2+0.5, frame.size.height/2+0.5);
            [self addSubview:circle];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
            [_scrollView addGestureRecognizer:tapGesture];
            [tapGesture release];
        }
        _scrollView.contentSize = CGSizeMake(1000, 92);
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions
//////////////////////////////////////////////////////////////////////////

- (void)scrollViewTapped:(UITapGestureRecognizer *)tapGesture
{
    CGPoint location = [tapGesture locationInView:self];
    if (location.x < self.frame.size.width/3)
    {
        [self goLeft];
    }
    else if(location.x > self.frame.size.width*2/3)
    {
        [self goRight];
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (void)goLeft
{
    if (_scrollView.contentOffset.x >= 100)
    {
        [UIView animateWithDuration:0.2 animations:^()
        {
            _scrollView.contentOffset = CGPointMake((floorf(_scrollView.contentOffset.x/100)-1)*100,0);
        }];
    }
}

- (void)goRight
{
    if (_scrollView.contentOffset.x <= 800)
    {
        [UIView animateWithDuration:0.2 animations:^()
         {
             _scrollView.contentOffset = CGPointMake((floorf(_scrollView.contentOffset.x/100)+1)*100,0);
         }];
    }
}

@end
