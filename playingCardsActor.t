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
	playingCardsHandClass = PlayingCardsHand

	getPlayingCardsHand() {
		if(playingCardsHand == nil) {
			playingCardsHand = getPlayingCardsHandClass()
				.createInstance();
			playingCardsHand.owner = self;
		}

		return(playingCardsHand);
	}

	getPlayingCardsHandClass() { return(playingCardsHandClass); }

	hasPlayingCard(id) { return(getPlayingCardsHand().hasCard(id)); }
;
