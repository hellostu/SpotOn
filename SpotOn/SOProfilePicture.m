//
//  SOProfilePicture.m
//  SpotOn
//
//  Created by Stuart Lynch on 22/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOProfilePicture.h"
#import <QuartzCore/QuartzCore.h>

@implementation SOProfilePicture

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithType:(SOProfilePictureType)profilePictureType
{
    CGRect outerFrame;
    CGRect innerFrame;
    UIImage *image;
    if (profilePictureType == SOProfilePictureTypeLarge)
    {
        outerFrame = CGRectMake(0, 0, 92, 92);
        innerFrame = CGRectMake(0, 0, 78, 78);
        image = [UIImage imageNamed:@"gameover_avatar.png"];
    }
    else
    {
        outerFrame = CGRectMake(0, 0, 61, 61);
        innerFrame = CGRectMake(0, 0, 50, 50);
        image = [UIImage imageNamed:@"avatar_head_set.png"];
    }
    
    if ( (self = [super initWithFrame:outerFrame]) != nil)
    {
        self.dashedLine = YES;
        self.fillColor = nil;
        self.strokeColor = GREY_COLOR_TOP_TEXT;
        
        _imageView = [[UIImageView alloc] initWithFrame:innerFrame];
        _imageView.layer.cornerRadius = roundf(innerFrame.size.width/2);
        _imageView.layer.masksToBounds = YES;
        _imageView.center = CGPointMake(self.frame.size.width/2-1, self.frame.size.height/2-1);
        _imageView.image = image;

        [self addSubview:_imageView];
    }
    return self;
}

- (void)dealloc
{
    [_imageView release];
    [super dealloc];
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
