#charset "us-ascii"
//
// playingCardsDiscardPile.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

class DiscardPile: PlayingCardsObject, Thing
	'discard pile/discards' 'discard pile'
	"It's the discard pile.  <<discardPileDesc()>> "

	_sizeDescriptions = static [
		1 -> 'a single card',
		2 -> 'a couple cards',
		5 -> 'a few cards',
		10 -> 'several cards',
		26 -> 'many cards',
		40 -> 'most of the cards',
		52 -> 'almost all of the cards'
	]

	_numberOfCards = 0

	addCard() { _numberOfCards += 1; }
	getCardCount() { return(_numberOfCards); }
	getSizeDescription(v) {
		local i, k;

		k = _sizeDescriptions.keysToList();
		for(i = 1; i <= k.length; i++) {
			if(v <= k[i])
				return(_sizeDescriptions[k[i]]);
				
		}

		return(nil);
	}
	discardPileDesc() {
		local txt;

		if((txt = getSizeDescription(_numberOfCards)) == nil)
			return('');
		return('It contains <<txt>>.');
	}

	clear() {
		self.moveInto(nil);
		_numberOfCards = 0;
	}

	setup(deckObj) {
		if(location != nil)
			return;
		if((deckObj == nil) || !deckObj.ofKind(CardDeck))
			return;
		self.moveInto(deckObj.getOutermostRoom());
		_numberOfCards = 0;
	}
;
