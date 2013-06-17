//
//  SODialogView.m
//  SpotOn
//
//  Created by Stuart Lynch on 17/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SODialogView.h"

@implementation SODialogView

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame titleText:(NSString *)titleText messageText:(NSString *)messageText
{
    if ( (self = [super initWithFrame:frame]) != nil)
    {
        self.layer.cornerRadius = 2.0f;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, frame.size.width-10, 30)];
        _titleLabel.text = titleText;
        _titleLabel.font = [UIFont fontWithName:@"GothamHTF-Light" size:26.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        
        _messageLabel = [[UITextView alloc] initWithFrame:CGRectMake(5, 60, frame.size.width-10, frame.size.height-70)];
        _messageLabel.text = messageText;
        _messageLabel.font = [UIFont fontWithName:@"GothamHTF-Medium" size:18.0f];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.userInteractionEnabled = NO;
        
        [self addSubview:_titleLabel];
        [self addSubview:_messageLabel];
    }
    return self;
}

@end
