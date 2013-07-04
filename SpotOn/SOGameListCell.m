//
//  SOGameListCell.m
//  SpotOn
//
//  Created by Stuart Lynch on 23/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOGameListCell.h"
#define DELETE_BUTTON_WIDTH 90

@interface SOGameListCell () <UIGestureRecognizerDelegate>
{
    UILabel             *_textLabel;
    UILabel             *_detailTextLabel;
    
    UIView              *_frontView;
    UITableView         *_tableView;
    SOGameListCellType  _gameListCellType;
    
    UIButton            *_deleteButton;
    
    CGFloat             _gestureOffset;
    BOOL                _editing;
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
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        backgroundView.backgroundColor = RED_COLOR;
        
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(320-DELETE_BUTTON_WIDTH, 0, DELETE_BUTTON_WIDTH, self.frame.size.height)];
        _deleteButton.titleLabel.textColor = [UIColor whiteColor];
        _deleteButton.titleLabel.font = [UIFont fontWithName:@"GothamHTF-Medium" size:16];
        _deleteButton.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [backgroundView addSubview:_deleteButton];
        
        _frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _frontView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _frontView.backgroundColor = GREY_COLOR_BTM_BACKGROUND;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
        panGesture.delegate = self;
        [_frontView addGestureRecognizer:panGesture];
        [panGesture release];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wasTapped:)];
        tapGesture.delegate = self;
        [_frontView addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 16, 210, 20)];
        _detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 36, 210, 18)];
        _textLabel.backgroundColor = self.backgroundColor;
        _detailTextLabel.backgroundColor = self.backgroundColor;
        
        self.textLabel.font = [UIFont fontWithName:@"GothamHTF-Medium" size:15.0f];
        self.textLabel.textColor = GREY_COLOR_TOP_TEXT;
        self.detailTextLabel.font = [UIFont fontWithName:@"GothamHTF-Light" size:14.0f];
        self.detailTextLabel.textColor = GREY_COLOR_TOP_TEXT;
        self.textLabel.textColor = GREY_COLOR_TOP_TEXT;
        
        _tableView = tableView;
        
        UIView *profilePictureOuterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 71)];
        _profilePicture = [[SOProfilePicture alloc] initWithType:SOProfilePictureTypeSmall];
        _profilePicture.center = CGPointMake(profilePictureOuterView.frame.size.width/2+10, profilePictureOuterView.frame.size.height/2+1);
        [profilePictureOuterView addSubview:_profilePicture];
        
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 71)];
        selectedView.backgroundColor = GREY_COLOR_TOP_TEXT_LIGHT;
        
        [_frontView addSubview:profilePictureOuterView];
        self.selectedBackgroundView = selectedView;
        [_frontView addSubview:_textLabel];
        [_frontView addSubview:_detailTextLabel];
        [self.contentView addSubview:backgroundView];
        [self.contentView addSubview:_frontView];
        [backgroundView release];
        
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
            [_deleteButton addTarget:self action:@selector(declineButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            self.accessoryView = wrapperView;
        }
        else if(gameListCellType == SOGameListCellTypeEndedGame)
        {
            [_deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [_deleteButton addTarget:self action:@selector(quitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        _greenCircle = [[SOCircle alloc] initWithFrame:CGRectMake(0, 0, 16, 16) expandTouchArea:NO];
        _greenCircle.fillColor = GREEN_COLOR;
        _greenCircle.center = CGPointMake(self.frame.size.width*0.9, self.frame.size.height/2);
        _greenCircle.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _greenCircle.hidden = YES;
        [_frontView addSubview:_greenCircle];
        
        [profilePictureOuterView release];
        [selectedView release];
    }
    return self;
}

- (void)dealloc
{
    [_frontView release];
    [_textLabel release];
    [_detailTextLabel release];
    [_profilePicture release];
    [_deleteButton release];
    [_greenCircle release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Overwridden Properties
//////////////////////////////////////////////////////////////////////////

- (UILabel *)textLabel
{
    return _textLabel;
}

- (UILabel *)detailTextLabel
{
    return _detailTextLabel;
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions
//////////////////////////////////////////////////////////////////////////

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class])
    {
        UIView *cell = [gestureRecognizer view];
        CGPoint translation = [gestureRecognizer translationInView:[cell superview]];
        
        // Check for horizontal gesture
        if (fabsf(translation.x) > fabsf(translation.y))
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if([gestureRecognizer isKindOfClass:UITapGestureRecognizer.class])
    {
        if (_editing == YES)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if([gestureRecognizer isKindOfClass:UILongPressGestureRecognizer.class])
    {
        if (_editing == YES)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return YES;
}

- (void)wasTapped:(UITapGestureRecognizer *)tapGesture
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:self];
    if ([_tableView.dataSource tableView:_tableView canEditRowAtIndexPath:indexPath] == YES)
    {
        if (_editing == YES)
        {
            [self stopEditing];
        }
    }
}

- (void)didPan:(UIPanGestureRecognizer *)panGesture
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:self];
    if ([_tableView.dataSource tableView:_tableView canEditRowAtIndexPath:indexPath] == YES)
    {
        CGPoint location = [panGesture locationInView:self];
        CGPoint center = _frontView.center;
        switch (panGesture.state)
        {
            case UIGestureRecognizerStateBegan:
            {
                _gestureOffset = center.x-location.x;
                if (_gameListCellType == SOGameListCellTypeInvite)
                {
                    [_deleteButton setTitle:@"Decline" forState:UIControlStateNormal];
                }
                else if(_gameListCellType == SOGameListCellTypeEndedGame)
                {
                    [_deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
                }
                else
                {
                    [_deleteButton setTitle:@"Quit" forState:UIControlStateNormal];
                }
                break;
            }
            case UIGestureRecognizerStateEnded:
            {
                if (_editing == NO)
                {
                    if (center.x < 150)
                    {
                        [self beginEditing];
                    }
                    else
                    {
                        [self stopEditing];
                    }
                }
                else
                {
                    if (center.x < 160-DELETE_BUTTON_WIDTH+10)
                    {
                        [self beginEditing];
                    }
                    else
                    {
                        [self stopEditing];
                    }
                }
                break;
            }
            default:
            {
                center.x = MIN(MAX(location.x+_gestureOffset,160-DELETE_BUTTON_WIDTH),160);
                _frontView.center = center;
                break;
            }
        }
    }
}

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

- (void)quitButtonPressed:(id)sender

{
    if ([self.delegate respondsToSelector:@selector(gameListCell:didQuitAtIndexPath:)])
    {
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tableView];
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:buttonPosition];
        [self.delegate gameListCell:self didQuitAtIndexPath:indexPath];
    }
}

- (void)deleteButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(gameListCell:didDeleteAtIndexPath:)])
    {
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tableView];
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:buttonPosition];
        [self.delegate gameListCell:self didDeleteAtIndexPath:indexPath];
    }
}

//////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
//////////////////////////////////////////////////////////////////////////

- (void)beginEditing
{
    [UIView animateWithDuration:0.2 animations:^() {
        CGPoint center = _frontView.center;
        center.x = 160-DELETE_BUTTON_WIDTH;
        _frontView.center = center;
    }];
    _editing = YES;
    [self stopEditingOthers];
}

- (void)stopEditingOthers
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:self];
    for (int i=0; i<[_tableView numberOfSections]; i++)
    {
        for (int j=0; j<[_tableView numberOfRowsInSection:i]; j++)
        {
            if ((indexPath.row ==j && indexPath.section == i) == NO)
            {
                SOGameListCell *cell = (SOGameListCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                if ([cell isKindOfClass:SOGameListCell.class])
                {
                    [cell stopEditing];
                }
            }
        }
    }
}

- (void)stopEditing
{
    [UIView animateWithDuration:0.2 animations:^() {
        CGPoint center = _frontView.center;
        center.x = 160;
        _frontView.center = center;
    } completion:^(BOOL finished) {
        [_deleteButton setTitle:@"" forState:UIControlStateNormal];
    }];
    _editing = NO;
}

@end
