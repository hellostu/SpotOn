//
//  SOGameCenterViewController.h
//  SpotOn
//
//  Created by Stuart Lynch on 18/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOTransitionContainer.h"

@class SOGameCenterViewController;

typedef enum  {
    SOGameTypeNewGame,
    SOGameTypeExistingGame
} SOGameType;

@interface SOGameCenterViewController : SOTransitionContainer

- (id)initWithGameType:(SOGameType)gameType;

@end
