//
//  SLGameViewController.h
//  Mastermind
//
//  Created by Stuart Lynch on 13/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SOGameViewController;
@protocol SOGameViewControllerDelegate;

typedef enum  {
    SLGameStateWaitingForGuess,
    SLGameStateGuessInput
} SLGameState;

@interface SOGameViewController : UIViewController

@property(nonatomic, readonly) SLGameState gameState;
@property(nonatomic, readonly) SLPlayType playType;
@property(nonatomic, readwrite, assign) id<SOGameViewControllerDelegate> delegate;

- (id)initWithPlayType:(SLPlayType)playType code:(NSArray *)code;

- (NSDictionary *)provideFeedbackForCode:(NSArray *)code;
- (void)setFeedbackWithRightColorsRightPosition:(int)rightColorsRightPosition
                       rightColorsWrongPosition:(int)rightColorsWrongPosition;

@end

@protocol SOGameViewControllerDelegate <NSObject>

@optional
- (void)gameViewController:(SOGameViewController *)gameViewController didTakeTurnWithCode:(NSArray *)code;
- (void)gameViewControllerReadyToTransition:(SOGameViewController *)gameViewController;
@end
