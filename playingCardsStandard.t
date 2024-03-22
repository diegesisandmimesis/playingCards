#charset "us-ascii"
//
// playingCards.t
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

class StandardPlayingCard: PlayingCard
	val = nil
	cardType = standardPlayingCards

	primes = static [ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41 ]

	computeValue() {
		local i, k, s;

		k = rank - 1;
		s = 0x8000;
		for(i = 1; i < (5 - suit); i++, s >>= 1);
		val = primes[rank] | (k << 8) | s | (1 << (16 + k));
	}
;

standardPlayingCards: PlayingCards
	'
	(2) (3) (4) (5) (6) (7) (8) (9) (10) (j) (k) (q) (of)
	(jack) (queen) (king) (ace)
	s h d c
	spades hearts diamonds clubs
	2s 3s 4s 5s 6s 7s 8s 9s 10s js qs ks as
	2h 3h 4h 5h 6h 7h 8h 9h 10h jh qh kh ah
	2d 3d 4d 5d 6d 7d 8d 9d 10d jd qd kd ad
	2c 3c 4c 5c 6c 7c 8c 9c 10c jc qc kc ac
	pokerCard'
	'playing card'

	cardClass = StandardPlayingCard

	// Constants
	suitShort = static [ 'S', 'H', 'D', 'C' ]
	suitSymbol = static [ '\u2660', '\u2665', '\u2666', '\u2663' ]
	suitLong = static [ 'spades', 'hearts', 'diamonds', 'clubs' ]

	rankShort = static [ '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J',
		'Q', 'K', 'A' ]
	rankLong = static [ 'two', 'three', 'four', 'five', 'six', 'seven',
		'eight', 'nine', 'ten', 'jack', 'queen', 'king', 'ace' ]

	//otherShort = static [ 'joker' ]
	//otherLong = static [ 'joker' ]
;

class StandardDeck: Deck
	cardCount = 52
	suits = 4
	ranks = 13
	playingCardClass = StandardPlayingCard

	initializeDeck() {
		local i, j, k, n, o, s;

		_deck = new Vector(cardCount);
		s = 0x8000;

		n = 0;
		for(j = 1; j <= 4; j++, s >>= 1) {
			for(i = 1; i <= 13; i++) {
				o = playingCardClass.createInstance(i, 5 - j);
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
