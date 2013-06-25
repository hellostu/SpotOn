//
//  SOGameListCell.m
//  SpotOn
//
//  Created by Stuart Lynch on 23/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOGameListCell.h"

@interface SOGameListCell ()
{
    UITableView *_tableView;
    SOGameListCellType _gameListCellType;
}
@end

@implementation SOGameListCell

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
//////////////////////////////////////////////////////////////////////////

- (id)initWithType:(SOGameListCellType)gameListCellType tableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) != nil)
    {
        self.backgroundColor = GREY_COLOR_BTM_BACKGROUND;
        
        self.textLabel.font = [UIFont fontWithName:@"GothamHTF-Medium" size:15.0f];
        self.textLabel.textColor = GREY_COLOR_TOP_TEXT;
        self.detailTextLabel.font = [UIFont fontWithName:@"GothamHTF-Medium" size:11.0f];
        self.detailTextLabel.textColor = GREY_COLOR_TOP_TEXT;
        self.textLabel.textColor = GREY_COLOR_TOP_TEXT;
        
        _tableView = tableView;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 71)];
        _profilePicture = [[SOProfilePicture alloc] initWithType:SOProfilePictureTypeSmall];
        _profilePicture.center = CGPointMake(contentView.frame.size.width/2+10, contentView.frame.size.height/2+1);
        [contentView addSubview:_profilePicture];
        
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 71)];
        selectedView.backgroundColor = GREY_COLOR_TOP_TEXT_LIGHT;
        
        [self.contentView addSubview:contentView];
        self.selectedBackgroundView = selectedView;
        
        _gameListCellType = gameListCellType;
        
        if (gameListCellType == SOGameListCellTypeInvite)
        {
            UIView *wrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 71)];
            UIButton *acceptButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
            [acceptButton setImage:[UIImage imageNamed:@"check_newgame.png"] forState:UIControlStateNormal];
            [acceptButton setImage:[UIImage imageNamed:@"check_newgame_active.png"] forState:UIControlStateHighlighted];
            acceptButton.center = CGPointMake(wrapperView.frame.size.width*0.1, wrapperView.frame.size.height/2);
            acceptButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
            [acceptButton addTarget:self action:@selector(acceptButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [wrapperView addSubview:acceptButton];
            [acceptButton release];
            
            UIButton *declineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
            [declineButton setImage:[UIImage imageNamed:@"x_newgame.png"] forState:UIControlStateNormal];
            [declineButton setImage:[UIImage imageNamed:@"x_newgame_active.png"] forState:UIControlStateHighlighted];
            declineButton.center = CGPointMake(wrapperView.frame.size.width*0.6, wrapperView.frame.size.height/2);
            declineButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
            [declineButton addTarget:self action:@selector(declineButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [wrapperView addSubview:declineButton];
            [declineButton release];
            
            self.accessoryView = wrapperView;
        }
        
        [contentView release];
        [selectedView release];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(100, 16, 210, 20);
    self.detailTextLabel.frame = CGRectMake(100, 36, 210, 18);
}

- (void)dealloc
{
    [_profilePicture release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions
//////////////////////////////////////////////////////////////////////////

- (void)acceptButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(gameListCell:didAcceptInviteAtIndexPath:)])
    {
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tableView];
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:buttonPosition];
        [self.delegate gameListCell:self didAcceptInviteAtIndexPath:indexPath];
    }
}

- (void)declineButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(gameListCell:didDeclineInviteAtIndexPath:)])
    {
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tableView];
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:buttonPosition];
        [self.delegate gameListCell:self didDeclineInviteAtIndexPath:indexPath];
    }
}

@end
