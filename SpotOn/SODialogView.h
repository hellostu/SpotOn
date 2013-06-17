//
//  SODialogView.h
//  SpotOn
//
//  Created by Stuart Lynch on 17/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SODialogView : UIView

@property(nonatomic, retain) UILabel *titleLabel;
@property(nonatomic, retain) UITextView *messageLabel;

- (id)initWithFrame:(CGRect)frame titleText:(NSString *)titleText messageText:(NSString *)messageText;

@end
