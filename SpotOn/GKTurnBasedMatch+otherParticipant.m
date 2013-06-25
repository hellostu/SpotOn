//
//  GKTurnBasedMatch+otherParticipant.m
//  SpotOn
//
//  Created by Stuart Lynch on 23/06/2013.
//  Copyright (c) 2013 UEA. All rights reserved.
//

#import "GKTurnBasedMatch+otherParticipant.h"

@implementation GKTurnBasedMatch (otherParticipant)
@dynamic otherParticipant;
@dynamic localParticipant;

- (GKTurnBasedParticipant *)otherParticipant
{
    for (GKTurnBasedParticipant *participant in self.participants)
    {
        if ([participant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID] == NO)
        {
            return participant;
        }
    }
    return nil;
}

- (GKTurnBasedParticipant *)localParticipant
{
    for (GKTurnBasedParticipant *participant in self.participants)
    {
        if ([participant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID] == YES)
        {
            return participant;
        }
    }
    return nil;
}

@end
