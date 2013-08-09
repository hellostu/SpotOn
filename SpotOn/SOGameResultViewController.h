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
    SOGameResultTie
} SOGameResult;

@interface SOGameResultViewController : SOMessageViewController

@property(nonatomic, readonly) SOProfilePicture *topProfilePicture;
@property(nonatomic, readonly) SOProfilePicture *bottomProfilePicture;
@property(nonatomic, retain) NSString *topScreenName;
@property(nonatomic, retain) NSString *bottomScreenName;

- (id)initWithGameResult:(SOGameResult)gameResult numberOfColors:(int)numberOfColors;

- (void)setTopCode:(NSArray *)topCode;
- (void)setBottomCode:(NSArray *)bottomCode;

@end
