#charset "us-ascii"
//
// playingCards.t
//
//	A TADS3/adv3 module implementing playing cards.
//
//	The module implements just the cards themselves (and some basic
//	actions involving them).  It does not implement any card game
//	mechanics.
//
//
// USAGE
//
//	Basic usage is to just declare an in-game object that's an
//	instance of one of the module-provided card deck classes.  The
//	base Deck class is an abstract class, and shouldn't be
//	instanced directly.
//
//	For most games what you probably want is the StandardDeck class,
//	which implements the familiar 52-card French-suited deck:
//
//		someRoom: Room 'Example Room'
//			"This is a placeholder room for the example. "
//		;
//		+cards: StandardDeck;
//
//
// ACTIONS
//
//	The module provides a >SHUFFLE action, a >DEAL action, and a
//	>DISCARD action.
//
//		SHUFFLE [object]
//			Shuffles the object.  By default Thing treats
//			SHUFFLE as illogical, and Deck handles it by
//			shuffling the deck.
//
//		DEAL [count [object]]
//			Deals some number of the given object(s).  By
//			Default Thing treats DEAL as illogical, and
//			the card-like objects (in-game Thing and Unthing
//			instances) prodvided by the module expect a count.
//
//			If successful, the actor doing the action will
//			end up holding the requested number of cards.  The
//			cards are "virtual" objects handled by a single
//			in-game PlayingCardsHand instance.
//
//		DISCARD [object list]
//			Discards the given object(s).  By default Thing
//			treats DISCARD as illogical, and the card-like
//			objects (in-game Thing and Unthing instances) provided
//			by the module handle it by discarding the requested
//			cards.
//
//
// SAMPLE TRANSCRIPT
//
//	This is a sample transcript from one of the demo games,
//	demo/src/interactive.t .
//
//		Void
//		This is a featureless void.
//
//		You see a deck of cards and a pebble here.
//
//		>X CARDS
//		It's a deck of playing cards.
//
//		>SHUFFLE
//		(the deck of cards)
//		You shuffle the cards.
//
//		>DEAL 5 CARDS
//		You deal five cards.
//
//		>X CARDS
//		(your cards)
//		You have: 5S 5H 6D 9H KS
//
//		>X 5S
//		There's nothing special about the five of spades.
//
//		>X 6S
//		You see no six of spades here.
//
//		>DISCARD 5S, 6S
//		You discard one card: the five of spades.  You can't
//		discard the six of spades because you aren't holding it.
//
//		>L
//		Void
//		This is a featureless void.
//
//		You see a deck of cards, a pebble, and a discard pile here.
//
//
// CARD TYPES
//
//	By default the module provides the standard 52-card French-suited
//	deck.
//
//	Support for several other deck types can be enabled at compile
//	time by including the appropriate flag for each additional deck
//	type:
//
//		PLAYING_CARDS_HANAFUDA
//			Enables hanafuda cards.  As of this writing, support
//			is limited.  Basic functions work, but the module
//			doesn't provide any way of differentiating between
//			equivalent cards (which is not a problem for any
//			of the other deck types in the module, which don't
//			have duplicate cards).
//
//		PLAYING_CARDS_SPANISH
//			Enables 40-card Spanish-suited card decks.
//
//		PLAYING_CARDS_TAROT
//			Enables 78-card tarot decks, using the Waite-Rider
//			nomenclature (swords, cups, pentacles, wands).
//
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

// Module ID for the library
playingCardsModuleID: ModuleID {
        name = 'Playing Cards Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

// Base object class for the module.
class PlayingCardsObject: Syslog syslogID = 'PlayingCards';

// Base playing card class.
// This is an abstract class for individual cards.  Intended to be
// extended by subclassing for each particular type of cards (standard
// 52-card playing cards, tarot cards, and so on).
class PlayingCard: PlayingCardsObject
	rank = nil		// the pip value of the card
	suit = nil		// the card's suit
	index = nil

	cardType = nil		// reference to the PlayingCards instance for
				// our "type"

	construct(r?, s?, idx?) {
		rank = r;
		suit = s;
		index = idx;
	}

	// Returns boolean true of the arg is a playing card and its
	// rank and suit equal ours.
	equals(c) {
		if((c == nil) || !c.ofKind(PlayingCard))
			return(nil);
		return((c.suit == suit) && (c.rank == rank));
	}

	// Returns the long and short names.  For example "two of clubs"
	// and "2C", respectively.
	getLongName() { return(cardType ? cardType.getLongName(self) : nil); }
	getShortName() { return(cardType ? cardType.getShortName(self) : nil); }
;
