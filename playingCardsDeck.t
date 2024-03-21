#charset "us-ascii"
//
// playingCardsDeck.t
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

class Deck: PlayingCardsObject
	_deck = nil
	_prng = nil
	index = 0

	primes = static [ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41 ]

	construct(p?) {
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

	draw() {
		if((_deck == nil) || (_deck.length() < 1))
			return(nil);
		index += 1;
		if(index > _deck.length)
			return(nil);
		return(_deck[index]);
	}

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

	initializeDeck() {
		local i, j, k, n, o, s;

		_deck = new Vector(52);
		s = 0x8000;

		n = 0;
		for(j = 1; j <= 4; j++, s >>= 1) {
			for(i = 1; i <= 13; i++) {
				o = new PlayingCard(i, 5 - j);
				k = i - 1;
				o.val = primes[i] | (k << 8)
					| s | (1 << (16 + k));
				o.index = n;
				n += 1;

				_deck.append(o);
			}
		}
	}
;