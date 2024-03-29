#charset "us-ascii"
//
// playingCardsStandard.t
//
//	Definitions for standard 52-card French-suited decks.
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

class StandardCard: PlayingCard
	cardType = StandardCardType
;

class StandardCardType: PlayingCardType
	cardClass = StandardCard
	deckClass = StandardDeck

	// Constants
	suitShort = static [ 'S', 'H', 'D', 'C' ]
	suitSymbol = static [ '\u2660', '\u2665', '\u2666', '\u2663' ]
	suitLong = static [ 'spades', 'hearts', 'diamonds', 'clubs' ]

	rankShort = static [ '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J',
		'Q', 'K', 'A' ]
	rankLong = static [ 'two', 'three', 'four', 'five', 'six', 'seven',
		'eight', 'nine', 'ten', 'jack', 'queen', 'king', 'ace' ]
;

class StandardDeck: CardDeck
	cardCount = 52
	suits = 4
	ranks = 13
	cardType = StandardCardType
;
