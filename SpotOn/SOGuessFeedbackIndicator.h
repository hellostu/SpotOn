//
//  SLGuessFeedbackIndicator.h
//  DotGame
//
//  Created by Stuart Lynch on 15/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOGuessFeedbackIndicator : UIView

- (id)initWithNumberRecepticles:(int)numberOfRecepticles;
- (void)setRightColorRightPosition:(int)rightColorRightPosition andRightColorWrongPosition:(int)rightColorWrongPosition;

//ANIMATIONS
- (void)hideDots;
- (void)animateIn;

@end
