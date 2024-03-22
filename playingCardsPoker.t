#charset "us-ascii"
//
// playingCardsPoker.t
//
//	Poker-specific extensions to the standard deck.
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

// Standard cards with a little additional logic used to assign a unique
// value to each card in the deck.  The unique values are selected to
// make hand evaluation easier.  For more information, see the hand evaluator
// logic.
class PokerCard: StandardCard
	cardType = pokerCards

	uniqueValue = nil

	primes = static [ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41 ]
	suitMask = static [ 0x8000, 0x4000, 0x2000, 0x1000 ]

	computeValue() {
		local k;

		k = rank - 1;
		uniqueValue = primes[rank] | (k << 8)
			| suitMask[suit] | (1 << (16 + k));
	}
;

pokerCards: standardCards
	cardClass = PokerCard
;

class PokerDeck: StandardDeck
	cardClass = PokerCard

	initializeDeck() {
		// Create the deck as usual.
		inherited();

		// Assign a unique value to each card.
		_deck.forEach(function(o) {
			o.computeValue();
		});
	}
;
