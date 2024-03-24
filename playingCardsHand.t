#charset "us-ascii"
//
// playingCardsHand.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

class PlayingCardsHand: PlayingCardsObject, PersonalThing
	'(playing) (card) hand/cards' 'cards'

	_cards = perInstance(new Vector())

	_deck = nil

	isMassNoun = true
	isProperName = true
	isPlural = true
	isListedInInventory = true
	//isListedInContents = nil
	vocabLikelihood() {
		if(gAction && gAction.ofKind(DealAction))
			return(-30);
		return(playingCardCheck() ? 10 : -30);
	}
	hideFromAll(action) { return(true); }

	setCards(ar) { clearCards(); _cards += ar; }
	addCards(ar) { _cards += ar; }
	clearCards() { _cards.setLength(0); }

	playingCardCheck() { return(owner == gActor); }

	dobjFor(Examine) {
		action() {
			_describeHand();
		}
	}

	dobjFor(Default) {
		verify() {
			if(!playingCardCheck())
				dangerous;
		}
	}
	dobjFor(Deal) {
		verify() { inaccessible(&cantDealNotDeck); }
	}

	_describeHand() {
		if(_cards == nil) {
			"No cards. ";
			return;
		}
		sort();
		"You have: ";
		_cards.forEach(function(o) {
			"<<o.getShortName()>> ";
		});
		"\n ";
	}

	sort() {
		_cards.sort(nil, function(a, b) {
			if(a.rank == b.rank)
				return(a.suit - b.suit);
			return(a.rank - b.rank);
		});
	}

	setDeck(v) {
		_deck = v;
	}
;
