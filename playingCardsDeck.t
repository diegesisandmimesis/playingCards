#charset "us-ascii"
//
// playingCardsDeck.t
//
//	Generic class for handling card decks, including shuffling and
//	dealing.
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

class PlayingCardUnthing: Unthing '(single) (individual) card' 'card'
	notHereMsg = playerActionMessages.cantUseSingleCard
	dobjFor(Take) { verify() { illogical(&cantTakeSingleCard); } }
;

class PlayingCardsHandUnthing: Unthing '(playing) (card) hand/cards' 'cards'
	notHereMsg = playerActionMessages.cantUseNoHand
;

class Deck: PlayingCardsObject, Thing
	'deck (of) (card)/cards' 'deck of cards'
	"It's a deck of playing cards. "
	cardCount = 0			// number of cards in the deck
	cardType = nil			// class for individual cards
	suits = 0			// number of suits
	ranks = 0			// number of ranks per suit
	others = 0			// number of "other" cards

	_deck = nil			// array containing the cards
	_prng = nil			// PRNG instance
	index = 0			// current card in the deck

	_hands = perInstance(new Vector())

	playingCardUnthingClass = PlayingCardUnthing
	playingCardsHandUnthingClass = PlayingCardsHandUnthing

	vocabLikelihood() {
		if(gAction && gAction.ofKind(DealAction))
			return(10);
		return(0);
	}

	construct(p?) {
		// Make sure we have a PRNG.
		_prng = (p ? p : new PlayingCardsPRNG());
	}

	getPRNG() {
		if(_prng == nil)
			_prng = new PlayingCardsPRNG();
		return(_prng);
	}

	cardsLeft() {
		if(_deck == nil)
			initializeDeck();
		return(_deck.length - index);
	}

	// Deal n cards to m players.
	// Return value is an m-element array of n-element arrays.
	deal(n, m) {
		local i, j, r;

		if(cardsLeft() < (n * m))
			return(nil);

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

	// Draw an individual card from the top of the deck.
	draw() {
		if((_deck == nil) || (_deck.length() < 1))
			initializeDeck();
		index += 1;
		if(index > _deck.length)
			return(nil);
		return(_deck[index]);
	}

	// Shuffle, using Fischer/Yates.
	shuffle() {
		local i, k, tmp;

		if(_deck == nil)
			initializeDeck();
		for(i = _deck.length; i >= 1; i--) {
			k = getPRNG().random(1, i);
			tmp = _deck[i];
			_deck[i] = _deck[k];
			_deck[k] = tmp;
		}

		index = 0;
	}

	initializeThing() {
		inherited();

		playingCardUnthingClass.createInstance().moveInto(self);
		playingCardsHandUnthingClass.createInstance().moveInto(self);
		cardType.createInstance().moveInto(self);
	}

	getCardClass() {
		if(cardType == nil)
			return(nil);
		return(cardType.cardClass);
	}

	// Initialize the deck.
	// This creates a deck array in "manufacturer" order;  that is,
	// all the cards in order, unshuffled.
	initializeDeck() {
		local cls, i, j, o;

		if((cls = getCardClass()) == nil)
			return;
			
		_deck = new Vector(cardCount);

		for(j = 1; j <= suits; j++) {
			for(i = 1; i <= ranks; i++) {
				o = cls.createInstance(i, j);
				_deck.append(o);
			}
		}
		for(i = 1; i <= others; i++) {
			o = cls.createInstance(i, suits + 1);
			_deck.append(o);
		}

		index = 0;
	}

	dobjFor(Shuffle) {
		verify() {}
		action() {
			shuffle();
			defaultReport(&okayShuffle);
		}
	}

	dobjFor(Deal) {
		verify() {
			local n;

			if(gAction.numMatch == nil) {
				illogical(&cantDealNoCount);
				return;
			}

			n = gAction.numMatch.getval();
			if(n > cardCount)
				illogical(&cantDealNotThatManyCards, n,
					cardCount);
			if(n > cardsLeft()) {
				illogicalNow(&cantDealNotEnoughCards, n);
			}
		}
		action() {
			_deal(gAction.numMatch.getval());
		}
	}

	addHand(v) { _hands.appendUnique(v); v.setDeck(self); }
	removeHand(v) { _hands.removeElement(v); }
	clearHands() { _hands.setLength(0); }

	_deal(n) { dealHandFor(n, gActor); }

	dealHandFor(n, actor) {
		local hand, l;

		if(n == nil) {
			reportFailure(&cantDealNoCount);
			return;
		}
		hand = actor.getPlayingCardsHand();
		if(hand.location != actor)
			hand.moveInto(actor);

		if((l = deal(n, 1)) == nil) {
			reportFailure(&cantDealNotThatManyCards, n,
				cardsLeft());
			return;
		}
		hand.addCards(l[1]);

		defaultReport(&okayDeal, n);
	}

	getCard(id) {
		if(cardType == nil)
			return(nil);
		return(cardType.getCard(id));
	}
;
