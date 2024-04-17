#charset "us-ascii"
//
// playingCardsPreCondition.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

isHoldingCards: PreCondition
	checkPreCondition(obj, allowImplicit) {
		if(gActor == nil)
			return(nil);

		if(!gActor.canSee(gActor.getPlayingCardsHand())) {
			reportFailure(&cantExamineNoHand);
			exit;
		}

		return(nil);
	}
;
