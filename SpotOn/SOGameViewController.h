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
#import "SOCodeSelectionView.h"

@class SOGameViewController;
@protocol SOGameViewControllerDelegate;

typedef enum  {
    SOGameStateWaitingForGuess,
    SOGameStateGuessInput
} SOGameState;


@interface SOGameViewController : UIViewController

@property(nonatomic, readonly) SOGameState              gameState;
@property(nonatomic, readonly) SOPlayType               playType;
@property(nonatomic, readonly) SOButton                 *submitButton;
@property(nonatomic, readonly) SOPreviousGuessesView    *previousGuessesView;
@property(nonatomic, readonly) SOCodeSelectionView      *codeSelectionView;
@property(nonatomic, readonly) NSArray                  *code;
@property(nonatomic, readwrite, assign) id<SOGameViewControllerDelegate> delegate;

- (id)initWithPlayType:(SOPlayType)playType difficulty:(SODifficulty)difficulty code:(NSArray *)code;
- (NSArray *)guessHistory;
- (void)updateSubmitButton;

@end

@protocol SOGameViewControllerDelegate <NSObject>

@optional
- (void)gameViewController:(SOGameViewController *)gameViewController didTakeTurnWithCode:(NSArray *)code;
- (void)gameViewControllerReadyToTransition:(SOGameViewController *)gameViewController;
- (void)gameViewControllerDidLoadViews:(SOGameViewController *)gameViewController;
@end
