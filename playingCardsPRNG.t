#charset "us-ascii"
//
// playingCardsPRNG.t
//
//	A placeholder PRNG class.  As implemented it's just a baroque wrapper
//	around the builting PRNG.  We do it this way so the interface is
//	the same as the notReallyRandom module, to make dropping it in
//	as a replacement easier.
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

class PlayingCardsPRNG: PlayingCardsObject
	seed = nil

	construct(s?) {
		if(s == nil)
			s = rand(65535);

		randomize(RNG_ISAAC, s);

		seed = s;
	}

	random(min?, max?) {
		if(min == nil) min = 0;
		if(max == nil) max = min;
		if(min > max) min = max;
		if(max < min) max = min;

		return(rand(max - min + 1) + min);
	}
;
