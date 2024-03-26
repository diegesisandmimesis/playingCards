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

	clear() {
		clearCards();
		moveInto(nil);
	}

	playingCardCheck() { return(owner == gActor); }

	dobjFor(Examine) {
		verify() {}
		action() {
			if(getCarryingActor() != gActor)
				describeBacks();
			else
				describeHand();
		}
	}

	dobjFor(Discard) {
		verify() {
			illogical(&cantDiscardMustSpecify);
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

	describeBacks() {
		defaultReport('{You/he} {does}n\'t learn anything from
			looking at the backs of {your/his} cards. ');
	}

	describeHand() {
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

	getCard(id) {
		if(_deck == nil) {
			return(nil);
		}

		return(_deck.getCard(id));
	}

	getCardIndex(id) {
		local c, i;

		if(_cards == nil) {
			return(nil);
		}

		if((c = getCard(id)) == nil) {
			return(nil);
		}

		for(i = 1; i <= _cards.length; i++) {
			if(c.equals(_cards[i]))
				return(i);
		}

		return(nil);
	}

	hasCard(id) { return(getCardIndex(id) != nil); }

	getDiscardPile() {
		if(_deck == nil)
			return(nil);
		return(_deck.getDiscardPile());
	}

	discard(card) {
		local d, idx;

		if((idx = getCardIndex(card)) == nil)
			return(nil);

		_cards.removeElementAt(idx);

		if((d = getDiscardPile()) != nil) {
			d.setup(_deck);
			d.addCard();
		}

		return(true);
	}
;
