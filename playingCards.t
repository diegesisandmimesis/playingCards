#charset "us-ascii"
//
// playingCards.t
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

class PlayingCardsObject: Syslog syslogID = 'PlayingCards';

class PlayingCard: PlayingCardsObject
	rank = nil
	suit = nil
	index = nil

	cardType = nil

	construct(r?, s?, idx?) {
		rank = r;
		suit = s;
		index = idx;
	}

	equals(c) {
		if((c == nil) || !c.ofKind(PlayingCard))
			return(nil);
		return((c.suit == suit) && (c.rank == rank));
	}

	getLongName() { return(cardType ? cardType.getLongName(self) : nil); }
	getShortName() { return(cardType ? cardType.getShortName(self) : nil); }
;

class PlayingCards: MultiLoc, Vaporous, PlayingCardsObject;
