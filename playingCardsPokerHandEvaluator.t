#charset "us-ascii"
//
// playingCardsPokerHandEvaluator.t
//
// 	This is a poker hand evaluator almost identical to an older
//	version of  Cactus Kev's Poker Hand Evaluator from
// 	https://suffe.cool/poker/evaluator.html
//
//	This doesn't use the perfect hash function implemented in the
//	newer version of the code on that site, due to limitations in
//	TADS3.
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

#ifdef PLAYING_CARDS_POKER

// Poker hand evaluator.
pokerHandEvaluator: PlayingCardsObject
	// Returns the numeric value of the given five-card hand.
	getHandValue(c1, c2, c3, c4, c5) {
		local f, q, s;

		q = (c1 | c2 | c3 | c4 | c5) >> 16;
		if(c1 & c2 & c3 & c4 & c5 & 0xf000)
			return(flushes[q + 1]);

		s = uniqueFive[q + 1];
		if(s > 0)
			return(s);

		q = (c1 & 0xff) * (c2 & 0xff) * (c3 & 0xff) * (c4 & 0xff)
			* (c5 & 0xff);

		f = lookup(q);

		return(lookupValues[f + 1]);
	}

	// Evaluate the five-card hand, presented as an array of PlayingCard
	// instances.
	evaluateArray(v) {
		if((v == nil) || (v.length != 5))
			return(nil);
		return(evaluate(v[1].uniqueValue, v[2].uniqueValue,
			v[3].uniqueValue, v[4].uniqueValue, v[5].uniqueValue));
	}

	// Evaluate the given five-card hand.
	evaluate(c1, c2, c3, c4, c5) {
		return(new PokerHandValue(getHandValue(c1, c2, c3, c4, c5)));
	}

	// binary search through the products table
	lookup(k) {
		local low, high, mid;

		low = 0;
		high = 4887;

		while(low <= high) {
			// divide by two
			mid = (high + low) >> 1;
			if(k < products[mid + 1]) {
				high = mid - 1;
			} else if(k > products[mid + 1]) {
				low = mid + 1;
			} else {
				return(mid);
			}
		}

		return(nil);
	}
;

#endif // PLAYING_CARDS_POKER
