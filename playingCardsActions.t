#charset "us-ascii"
//
// playingCardsActions.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

DefineTAction(Shuffle);
VerbRule(Shuffle)
	'shuffle' singleDobj
	: ShuffleAction
	verbPhrase = 'shuffle/shuffling (what)'
;

modify Thing
	dobjFor(Shuffle) {
		verify() { illogical(&cantShuffleThat); }
	}
;

DefineTAction(Deal);
VerbRule(Deal)
	'deal' singleDobj | 'deal' singleNumber dobjList
	: DealAction
	verbPhrase = 'deal/dealing (what)'
;

modify Thing
	dobjFor(Deal) {
		verify() { illogical(&cantDealThat); }
	}
;

DefineTAction(Discard);
VerbRule(Discard)
	'discard' dobjList
	: DiscardAction
	verbPhrase = 'discard/discarding (what)'
;

modify Thing
	dobjFor(Discard) {
		verify() {
			dangerous;
			illogical(&cantDiscardThat);
		}
	}
;
