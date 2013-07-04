//
//  SOButtonsCell.h
//  SpotOn
//
//  Created by Stuart Lynch on 03/07/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOButton.h"

@class SOButtonsCell;
@protocol SOButtonsCellDelegate;

@interface SOButtonsCell : UITableViewCell

@property(nonatomic, readonly) SOButton *newButton;
@property(nonatomic, readonly) SOButton *moreButton;
@property(readwrite, assign) id<SOButtonsCellDelegate> delegate;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end

@protocol SOButtonsCellDelegate <NSObject>

@optional
- (void)buttonsCellTappedNew:(SOButtonsCell *)buttonsCell;
- (void)buttonsCellTappedMore:(SOButtonsCell *)buttonsCell;

@end