#charset "us-ascii"
//
// playingCardsSpanish.t
//
//	Definitions for 40-card Spanish-suited decks.
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

class SpanishCard: PlayingCard
	cardType = SpanishCardType
;

class SpanishCardType: PlayingCardType
	cardClass = SpanishCard
	cardDeck = SpanishDeck

	// Constants
	suitShort = static [ 'E', 'C', 'O', 'B' ]
	suitLong = static [ 'espadas', 'copas', 'oros', 'bastos' ]

	rankShort = static [ '1', '2', '3', '4', '5', '6', '7', 'S', 'C', 'R' ]
	rankLong = static [ 'one', 'two', 'three', 'four', 'five', 'six',
		'seven', 'sota', 'caballo', 'rey' ]
;

class SpanishDeck: CardDeck
	cardCount = 40
	suits = 4
	ranks = 10
	cardType = SpanishCardType
;
