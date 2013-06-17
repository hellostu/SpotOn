//
//  SLPassAndPlayTransitionViewController.h
//  DotGame
//
//  Created by Stuart Lynch on 15/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOMessageViewController.h"
@class SOPassAndPlayTransitionViewController;
@protocol SOPassAndPlayTransitionViewControllerDelegate;

@interface SOPassAndPlayTransitionViewController : SOMessageViewController

@property(nonatomic, readwrite, assign) SOPlayType playType;
@property(nonatomic, readwrite, assign) id<SOPassAndPlayTransitionViewControllerDelegate> delegate;

- (id)initWithPlayType:(SOPlayType)playType;

@end

@protocol SOPassAndPlayTransitionViewControllerDelegate <NSObject>

@optional
- (void)passAndPlayTransitionViewControllerReadyToTransition:(SOPassAndPlayTransitionViewController *)passAndPlay;

@end