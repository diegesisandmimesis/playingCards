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
	vocabLikelihood() {
		if(gAction && gAction.ofKind(DealAction))
			return(-30);
		return(playingCardCheck() ? 10 : -30);
	}
	hideFromAll(action) { return(true); }

	getCards() { return(_cards); }
	setCards(ar) { clearCards(); _cards += ar; }
	addCards(ar) { _cards += ar; }
	clearCards() { _cards.setLength(0); }
	removeCard(c) {
		local idx;

		if((idx = getCardIndex(c)) == nil)
			return(nil);

		_cards.removeElementAt(idx);

		return(true);
	}

	getDeck() { return(_deck); }

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
			illogical(&playingCardsCantDiscardMustSpecify);
		}
	}

	dobjFor(Default) {
		verify() {
			if(!playingCardCheck())
				dangerous;
		}
	}
	dobjFor(Deal) {
		verify() { inaccessible(&playingCardsCantDealNotDeck); }
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

	shortDescription() {
		local txt;

		if(_cards == nil)
			return('no cards');
		sort();
		txt = new StringBuffer();
		_cards.forEach(function(o) {
			txt.append('<<o.getShortName()>> ');
		});

		return(toString(txt));
	}

	sort() {
		if(_cards.length < 2)
			return;
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

	getCardsByRank(v) {
		local r;

		if(_cards == nil)
			return(nil);

		r = new Vector(_cards.length);
		_cards.forEach(function(o) {
			if(o.rank == v)
				r.append(o);
		});

		return(r);
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
		local d;
		//local d, idx;

		removeCard(card);
/*
		if((idx = getCardIndex(card)) == nil)
			return(nil);

		_cards.removeElementAt(idx);
*/

		if((d = getDiscardPile()) != nil) {
			d.setup(_deck);
			d.addCard();
		}

		if(_cards.length == 0)
			self.moveInto(nil);

		return(true);
	}

	handToText() {
		local v;

		if(_cards.length == 0)
			return('nothing');
		v = new Vector(_cards.length);
		_cards.forEach(function(o) {
			v.append('the ' + o.getLongName());
		});

		return(stringLister.makeSimpleList(v.toList()));
	}
;
