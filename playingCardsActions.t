#charset "us-ascii"
//
// playingCardsActions.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

class PlayingCardAction: Action;

class PlayingCardIAction: PlayingCardAction, IAction;
class PlayingCardTAction: PlayingCardAction, TAction;

//DefineTAction(Shuffle);
DefinePlayingCardTAction(Shuffle);
VerbRule(Shuffle)
	'shuffle' singleDobj
	: ShuffleAction
	verbPhrase = 'shuffle/shuffling (what)'
;

modify Thing
	dobjFor(Shuffle) {
		verify() { illogical(&playingCardsCantShuffleThat); }
	}
;

//DefineTAction(Deal);
DefinePlayingCardTAction(Deal);
VerbRule(Deal)
	'deal' singleDobj | 'deal' singleNumber dobjList
	: DealAction
	verbPhrase = 'deal/dealing (what)'
;

modify Thing
	dobjFor(Deal) {
		verify() { illogical(&playingCardsCantDealThat); }
	}
;

DefinePlayingCardTAction(Discard);
//DefineTAction(Discard);
VerbRule(Discard)
	'discard' dobjList
	: DiscardAction
	verbPhrase = 'discard/discarding (what)'
;

modify Thing
	dobjFor(Discard) {
		verify() {
			dangerous;
			illogical(&playingCardsCantDiscardThat);
		}
	}
;
