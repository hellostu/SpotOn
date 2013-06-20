//
//  SLPreviousGuessView.h
//  DotGame
//
//  Created by Stuart Lynch on 14/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOGuessFeedbackIndicator.h"

@interface SOPreviousGuessView : UIView

@property(nonatomic, readonly) NSArray *colors;
@property(nonatomic, readonly) SOGuessFeedbackIndicator *guessFeedbackIndicator;

- (id)initWithFrame:(CGRect)frame numberOfColors:(int)numberOfCircles index:(int)index;
- (void)updateWithColors:(NSArray *)colors;
- (void)setRightColorRightPosition:(int)rightColorRightPosition andRightColorWrongPosition:(int)rightColorWrongPosition animated:(BOOL)animated;
@end
