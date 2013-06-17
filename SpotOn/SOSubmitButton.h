//
//  SLSubmitButton.h
//  DotGame
//
//  Created by Stuart Lynch on 15/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SOSubmitButton;
@protocol SOSubmitButtonDelegate;

@interface SOSubmitButton : UIView

@property(nonatomic, readwrite, assign) id<SOSubmitButtonDelegate> delegate;
@property(nonatomic, readwrite, assign) BOOL enabled;

@end

@protocol SOSubmitButtonDelegate <NSObject>

@optional
- (void)submitButtonPressed:(SOSubmitButton *)submitButton;

@end