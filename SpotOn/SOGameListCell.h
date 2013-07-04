//
//  SOGameListCell.h
//  SpotOn
//
//  Created by Stuart Lynch on 23/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOProfilePicture.h"

@class SOGameListCell;
@protocol SOGameListCellDelegate;

typedef enum  {
    SOGameListCellTypeNormal,
    SOGameListCellTypeEndedGame,
    SOGameListCellTypeInvite,
} SOGameListCellType;

@interface SOGameListCell : UITableViewCell

@property(nonatomic, readonly) SOProfilePicture *profilePicture;
@property(nonatomic, readwrite, assign) id<SOGameListCellDelegate> delegate;
@property(nonatomic, readonly) SOCircle            *greenCircle;

- (id)initWithType:(SOGameListCellType)gameListCellType tableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;
- (void)stopEditing;

@end

@protocol SOGameListCellDelegate <NSObject>

@optional
- (void)gameListCell:(SOGameListCell *)gameListCell didAcceptInviteAtIndexPath:(NSIndexPath *)indexPath;
- (void)gameListCell:(SOGameListCell *)gameListCell didDeclineInviteAtIndexPath:(NSIndexPath *)indexPath;
- (void)gameListCell:(SOGameListCell *)gameListCell didQuitAtIndexPath:(NSIndexPath *)indexPath;
- (void)gameListCell:(SOGameListCell *)gameListCell didDeleteAtIndexPath:(NSIndexPath *)indexPath;

@end
