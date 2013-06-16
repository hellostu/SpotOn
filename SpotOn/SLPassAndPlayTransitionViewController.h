//
//  SLPassAndPlayTransitionViewController.h
//  DotGame
//
//  Created by Stuart Lynch on 15/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOMessageViewController.h"
@class SLPassAndPlayTransitionViewController;
@protocol SLPassAndPlayTransitionViewControllerDelegate;

@interface SLPassAndPlayTransitionViewController : SOMessageViewController

@property(nonatomic, readwrite, assign) SOPlayType playType;
@property(nonatomic, readwrite, assign) id<SLPassAndPlayTransitionViewControllerDelegate> delegate;

- (id)initWithPlayType:(SOPlayType)playType;

@end

@protocol SLPassAndPlayTransitionViewControllerDelegate <NSObject>

@optional
- (void)passAndPlayTransitionViewControllerReadyToTransition:(SLPassAndPlayTransitionViewController *)passAndPlay;

@end