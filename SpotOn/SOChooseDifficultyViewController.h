//
//  SOChooseDifficultyViewController.h
//  SpotOn
//
//  Created by Stuart Lynch on 22/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SOChooseDifficultyViewController;
@protocol SOChooseDifficultyViewControllerDelegate;

@interface SOChooseDifficultyViewController : UIViewController

@property(readwrite, assign) id<SOChooseDifficultyViewControllerDelegate> delegate;

@end

@protocol SOChooseDifficultyViewControllerDelegate <NSObject>

@optional
- (void)chooseDifficultyViewController:(SOChooseDifficultyViewController *)chooseDifficultyVC selectedDifficulty:(SODifficulty)difficulty;

@end
