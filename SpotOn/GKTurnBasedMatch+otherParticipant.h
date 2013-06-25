//
//  GKTurnBasedMatch+otherParticipant.h
//  SpotOn
//
//  Created by Stuart Lynch on 23/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import <GameKit/GameKit.h>

@interface GKTurnBasedMatch (otherParticipant)

@property(nonatomic, readonly) GKTurnBasedParticipant *otherParticipant;
@property(nonatomic, readonly) GKTurnBasedParticipant *localParticipant;
@end
