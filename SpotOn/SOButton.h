//
//  SLSubmitButton.h
//  DotGame
//
//  Created by Stuart Lynch on 15/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SOButton;
@protocol SOButtonDelegate;

typedef enum  {
    SOButtonTypeSubmit,
    SOButtonTypeBack,
    SOButtonTypeNext,
    SOButtonTypeText,
    SOButtonTypeDefault,
} SOButtonType;

@interface SOButton : UIView

@property(nonatomic, readwrite, assign) id<SOButtonDelegate> delegate;
@property(nonatomic, readwrite, assign) BOOL    enabled;
@property(nonatomic, readonly) SOButtonType     buttonType;
@property(nonatomic, readonly) UIColor          *fillColor;
@property(nonatomic, readonly) UILabel          *titleLabel;
@property(nonatomic, readonly) UILabel          *pressedTitleLabel;
@property(nonatomic, readonly) UILabel          *hoverTitleLabel;

- (id)initWithType:(SOButtonType)buttonType;

@end

@protocol SOButtonDelegate <NSObject>

@optional
- (void)buttonPressed:(SOButton *)button;

@end