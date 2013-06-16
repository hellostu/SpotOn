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
- (void)takeTurnWithColors:(NSArray *)colors;
- (void)scrollToTurnWithCompleition:(void (^)(void))completion;
- (void)scrollToEndAnimated:(BOOL)animated withCompletion:(void (^)(void))completion;
- (void)forLastTurnSetRightColorRightPosition:(int)rightColorRightPosition andRightColorWrongPosition:(int)rightColorWrongPosition;
- (void)addNewRow;
@end
