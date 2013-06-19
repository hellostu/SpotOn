//
//  SOGameCenterHelper.h
//  SpotOn
//
//  Created by Stuart Lynch on 18/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
@class SOGameCenterHelper;
@protocol SOGamerCenterHelperDelegate;

@interface SOGameCenterHelper : NSObject <GKTurnBasedMatchmakerViewControllerDelegate>

@property(nonatomic, readonly) BOOL gameCenterAvailable;
@property(nonatomic, readonly) BOOL userAuthenticated;

@property (nonatomic, retain) UIViewController *presentingViewController;
@property (nonatomic, retain) GKTurnBasedMatch *match;

@property(nonatomic, readwrite, assign) id<SOGamerCenterHelperDelegate> delegate;

+ (SOGameCenterHelper *)sharedInstance;
- (void)authenticateLocalUserWithHandler:(void (^)(UIViewController* viewController, NSError *error))handler;
- (void)findMatchWithPresentingViewController:(UIViewController *)presentingViewConroller;

@end

@protocol SOGamerCenterHelperDelegate <NSObject>

- (void)matchStarted;
- (void)matchEnded;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;

@end