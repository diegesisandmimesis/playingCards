#charset "us-ascii"
//
// playingCards.t
//
//	A TADS3/adv3 module implementing playing cards.
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
