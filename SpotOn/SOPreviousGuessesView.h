//
//  SLPreviousGuessesView.h
//  DotGame
//
//  Created by Stuart Lynch on 14/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOPreviousGuessesView : UIScrollView

@property(readonly) int turnsTaken;
- (id)initWithFrame:(CGRect)frame numberOfRecepticles:(int)numberOfRecepticles;
- (void)takeTurnWithColors:(NSArray *)colors;
- (void)scrollToTurnWithCompleition:(void (^)(void))completion;
- (void)scrollToEndAnimated:(BOOL)animated withCompletion:(void (^)(void))completion;
- (void)addNewRowAnimated:(BOOL)animated;
- (void)updateWithGuesses:(NSArray *)guesses;

- (NSDictionary *)provideFeedbackForGuess:(NSArray *)guess withOpponentsCode:(NSArray *)opponentsCode;
- (void)updateFeedbackIndicatorsWithOpponentsCode:(NSArray *)opponentsCode animated:(BOOL)animated;

- (NSArray *)guessesList;

- (BOOL)hasWon;
- (int)numberOfGuesses;
@end
