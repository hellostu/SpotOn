//
//  SLSubmitButton.h
//  DotGame
//
//  Created by Stuart Lynch on 15/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SOButton;
@protocol SOSubmitButtonDelegate;

typedef enum  {
    SOButtonTypeSubmit,
    SOButtonTypeNext,
} SOButtonType;

@interface SOButton : UIView

@property(nonatomic, readwrite, assign) id<SOSubmitButtonDelegate> delegate;
@property(nonatomic, readwrite, assign) BOOL enabled;
@property(nonatomic, readonly) SOButtonType buttonType;

- (id)initWithType:(SOButtonType)buttonType;

@end

@protocol SOSubmitButtonDelegate <NSObject>

@optional
- (void)submitButtonPressed:(SOButton *)submitButton;

@end