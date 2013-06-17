//
//  SOGameResultViewController.h
//  SpotOn
//
//  Created by Stuart Lynch on 16/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//
#import "SOMessageViewController.h"

typedef enum  {
    SOGameResultPlayerOneWin,
    SOGameResultPlayerTwoWin,
    SOGameResultDraw
} SOGameResult;


@interface SOGameResultViewController : SOMessageViewController

- (id)initWithWinType:(SOGameResult)winType player1Code:(NSArray *)player1Code player2Code:(NSArray *)player2Code;

@end
