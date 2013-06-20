//
//  SLGameViewController.h
//  Mastermind
//
//  Created by Stuart Lynch on 13/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOButton.h"
#import "SOPreviousGuessesView.h"

@class SOGameViewController;
@protocol SOGameViewControllerDelegate;

typedef enum  {
    SLGameStateWaitingForGuess,
    SLGameStateGuessInput
} SLGameState;

@interface SOGameViewController : UIViewController

@property(nonatomic, readonly) SLGameState              gameState;
@property(nonatomic, readonly) SOPlayType               playType;
@property(nonatomic, readonly) SOButton                 *submitButton;
@property(nonatomic, readonly) SOPreviousGuessesView    *previousGuessesView;
@property(nonatomic, readonly) NSArray                  *code;
@property(nonatomic, readwrite, assign) id<SOGameViewControllerDelegate> delegate;

- (id)initWithPlayType:(SOPlayType)playType code:(NSArray *)code;
- (NSArray *)guessHistory;

@end

@protocol SOGameViewControllerDelegate <NSObject>

@optional
- (void)gameViewController:(SOGameViewController *)gameViewController didTakeTurnWithCode:(NSArray *)code;
- (void)gameViewControllerReadyToTransition:(SOGameViewController *)gameViewController;
- (void)gameViewControllerDidLoadViews:(SOGameViewController *)gameViewController;
@end
