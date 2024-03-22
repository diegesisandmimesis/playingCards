#charset "us-ascii"
//
// playingCardsDeck.t
//
//	Generic class for handling card decks, including shuffling and
//	dealing.
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

class Deck: PlayingCardsObject
	cardCount = 0			// number of cards in the deck
	playingCardClass = PlayingCard	// class for individual cards
	suits = 0			// number of suits
	ranks = 0			// number of ranks per suit
	others = 0			// number of "other" cards

	_deck = nil			// array containing the cards
	_prng = nil			// PRNG instance
	index = 0			// current card in the deck

	construct(p?) {
		// Make sure we have a PRNG.
		_prng = (p ? p : new PlayingCardsPRNG());
	}

	// Deal n cards to m players.
	// Return value is an m-element array of n-element arrays.
	deal(n, m) {
		local i, j, r;

		r = new Vector(m, m);
		for(i = 1; i <= n; i++) {
			for(j = 1; j <= m; j++) {
				if(r[j] == nil)
					r[j] = new Vector(n);
				r[j].append(draw());
			}
		}
		return(r);
	}

	// Draw an individual card from the top of the deck.
	draw() {
		if((_deck == nil) || (_deck.length() < 1))
			return(nil);
		index += 1;
		if(index > _deck.length)
			return(nil);
		return(_deck[index]);
	}

	// Shuffle, using Fischer/Yates.
	shuffle() {
		local i, k, tmp;

		if(_deck == nil)
			initializeDeck();
		for(i = _deck.length; i >= 1; i--) {
			k = _prng.random(1, i);
			tmp = _deck[i];
			_deck[i] = _deck[k];
			_deck[k] = tmp;
		}

		index = 0;
	}

	// Initialize the deck.
	// This creates a deck array in "manufacturer" order;  that is,
	// all the cards in order, unshuffled.
	initializeDeck() {
		local i, j, o;

		_deck = new Vector(cardCount);

		for(j = 1; j <= suits; j++) {
			for(i = 1; i <= ranks; i++) {
				o = playingCardClass.createInstance(i, j);
				_deck.append(o);
			}
		}
		for(i = 1; i <= others; i++) {
			o = playingCardClass.createInstance(i, suits + 1);
			_deck.append(o);
		}
	}
;
