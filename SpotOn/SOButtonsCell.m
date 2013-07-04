//
//  SOButtonsCell.m
//  SpotOn
//
//  Created by Stuart Lynch on 03/07/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOButtonsCell.h"

@interface SOButtonsCell () <SOButtonDelegate>

@end

@implementation SOButtonsCell

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ( (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) != nil)
    {
        self.backgroundColor = GREY_COLOR_BTM_BACKGROUND;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _newButton = [[SOButton alloc] initWithType:SOButtonTypeText];
        _moreButton = [[SOButton alloc] initWithType:SOButtonTypeText];
        
        _newButton.delegate = self;
        _moreButton.delegate = self;
        
        _newButton.titleLabel.text = @"NEW";
        _newButton.pressedTitleLabel.text = @"NEW";
        _newButton.hoverTitleLabel.text = @"NEW";
        
        _moreButton.titleLabel.text = @"MORE";
        _moreButton.pressedTitleLabel.text = @"MORE";
        _moreButton.hoverTitleLabel.text = @"MORE";
        
        _newButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _moreButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        _newButton.center = CGPointMake(60, self.frame.size.height/2);
        _moreButton.center = CGPointMake(130, self.frame.size.height/2);
        
        [self.contentView addSubview:_newButton];
        [self.contentView addSubview:_moreButton];
    }
    return self;
}

- (void)dealloc
{
    [_newButton release];
    [_moreButton release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions
//////////////////////////////////////////////////////////////////////////

- (void)buttonPressed:(SOButton *)button
{
    if (button == _moreButton)
    {
        if ([self.delegate respondsToSelector:@selector(buttonsCellTappedMore:)])
        {
            [self.delegate buttonsCellTappedMore:self];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(buttonsCellTappedNew:)])
        {
            [self.delegate buttonsCellTappedNew:self];
        }
    }
}

@end
