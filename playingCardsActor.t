#charset "us-ascii"
//
// playingCardsActor.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

modify Actor
	playingCardsHand = nil

	getPlayingCardsHand() {
		if(playingCardsHand == nil) {
			playingCardsHand = new PlayingCardsHand();
			playingCardsHand.owner = self;
		}

		return(playingCardsHand);
	}

	hasPlayingCard(id) { return(getPlayingCardsHand().hasCard(id)); }
;
