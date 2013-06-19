//
//  SOTransitionContainer.h
//  SpotOn
//
//  Created by Stuart Lynch on 18/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOTransitionContainer : UIViewController

@property(nonatomic, readonly) UIViewController *activeViewController;

- (void)transitionToViewController:(UIViewController *)viewController;
- (id)initWithViewController:(UIViewController *)viewController;

@end
