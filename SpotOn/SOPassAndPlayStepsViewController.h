//
//  SOPassAndPlayerStepsViewController.h
//  SpotOn
//
//  Created by Stuart Lynch on 12/07/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOViewController.h"
@class SOPassAndPlayStepsViewController;
@protocol SOPassAndPlayStepsViewControllerDelegate;

@interface SOPassAndPlayStepsViewController : SOViewController

@property(nonatomic, readwrite, assign) id<SOPassAndPlayStepsViewControllerDelegate> delegate;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readwrite, assign) SOPlayType playType;

- (id)initWithStep:(int)step name:(NSString *)name difficulty:(SODifficulty)difficulty;

@end

@protocol SOPassAndPlayStepsViewControllerDelegate <NSObject>

@optional
- (void)passAndPlayStepsViewController:(SOPassAndPlayStepsViewController *)passAndPlayerViewController returnedWithStep:(int)step;
- (void)passAndPlayStepsViewController:(SOPassAndPlayStepsViewController *)passAndPlayerViewController returnedWithCode:(NSArray *)code;

@end