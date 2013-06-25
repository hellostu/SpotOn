//
//  SOLoadingViewController.h
//  SpotOn
//
//  Created by Stuart Lynch on 24/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SOLoadingViewController;
@protocol SOLoadingViewControllerDelegate;

@interface SOLoadingViewController : UIViewController

@property(nonatomic, assign, readwrite) id<SOLoadingViewControllerDelegate> delegate;

@end

@protocol SOLoadingViewControllerDelegate <NSObject>

- (void)loadingViewControllerStartedLoading:(SOLoadingViewController *)loadingViewController;

@end