//
//  SOChooseDifficultyViewController.h
//  SpotOn
//
//  Created by Stuart Lynch on 22/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    SOChooseFromThreeTypeDifficulty,
    SOChooseFromThreeTypeGameType
} SOChooseFromThreeType;

@class SOChooseFromThreeViewController;
@protocol SOChooseFromThreeControllerDelegate;

@interface SOChooseFromThreeViewController : UIViewController

@property(readwrite, assign) id<SOChooseFromThreeControllerDelegate> delegate;

- (id)initWithType:(SOChooseFromThreeType)chooseFromThreeType;

@end

@protocol SOChooseFromThreeControllerDelegate <NSObject>

@optional
- (void)chooseFromThreeViewController:(SOChooseFromThreeViewController *)chooseFromThreeVC selectedDifficulty:(SODifficulty)difficulty;
- (void)chooseFromThreeViewController:(SOChooseFromThreeViewController *)chooseFromThreeVC selectedPlayType:(SOPlayType)playType;

@end
