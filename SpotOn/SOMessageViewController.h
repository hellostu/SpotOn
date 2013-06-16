//
//  SLPassAndPlayTransitionViewController.h
//  DotGame
//
//  Created by Stuart Lynch on 15/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "SOViewController.h"

@interface SOMessageViewController : SOViewController

@property(nonatomic, readonly) UITextView           *messageView;
@property(nonatomic, readwrite, assign) SOPlayType  playType;

@end
