//
//  SOGameResultViewController.h
//  SpotOn
//
//  Created by Stuart Lynch on 22/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOMessageViewController.h"
#import "SOProfilePicture.h"

typedef enum  {
    SOGameResultWin,
    SOGameResultLose,
    SOGameResultTie
} SOGameResult;

@interface SOGameResultViewController : SOMessageViewController

@property(nonatomic, readonly) SOProfilePicture *ownProfilePicture;
@property(nonatomic, readonly) SOProfilePicture *opponentsProfilePicture;

- (id)initWithResult:(SOGameResult)gameResult
             ownCode:(NSArray *)ownCode
       opponentsCode:(NSArray *)opponentsCode
        ownBestGuess:(NSArray *)ownBestGuess
  opponentsBestGuess:(NSArray *)opponentsBestGuess;

@end
