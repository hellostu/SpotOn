//
//  SLChooseCodeViewController.h
//  DotGame
//
//  Created by Stuart Lynch on 15/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOMessageViewController.h"

@class SOChooseCodeViewController;
@protocol SOChooseCodeViewControllerDelegate;

@interface SOChooseCodeViewController : SOMessageViewController

@property(nonatomic, readwrite, assign) id<SOChooseCodeViewControllerDelegate> delegate;
@property(nonatomic, readonly) SLPlayType playerType;

- (id)initWithPlayType:(SLPlayType)mode;

@end

@protocol SOChooseCodeViewControllerDelegate <NSObject>

@optional
- (void)chooseCodeViewController:(SOChooseCodeViewController *)chooseCodeViewController didReturnCode:(NSArray *)code;

@end
