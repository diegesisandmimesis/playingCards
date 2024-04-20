#charset "us-ascii"
//
// playingCardsMsg.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

playingCardsStringListerOr: stringLister
	listSepTwo = " or "
	listSepEnd = ", or "
	longListSepTo = ", or "
	longListSepEnd = "; or "
;

modify playerActionMessages
	// Utility methods to format strings as command lines.  Used
	// when suggesting alternative commands in failure messages.
	formatInlineCommand(txt) {
		return('<b>&gt;<<toString(txt).toUpper()>></b>');
	}
	formatCommand(txt) {
		return('<.p>\n\t<<formatInlineCommand(txt)>><.p> ');
	}

	// Generic failure message.  Used when the PlayingCardType's vocabulary
	// was matched, but the matching noun phrase doesn't correspond to
	// a card name.  For example >EXAMINE SPADES will end up here, because
	// "spades" is part of the vocabulary, but it doesn't describe a
	// specific card.
	playingCardsBadName(lst) {
		if((lst != nil) && !lst.ofKind(Collection))
			lst = [ lst ];
		return('The story tried to interpret <<stringLister.makeSimpleList(lst)>> as the <<if(lst.length > 1)>>names of cards<<else>> name of a card<<end>> but failed. ');
	}

	// Generic action failure message:  the noun phrase matched a valid
	// card, but we don't have an action handler for the verb.
	playingCardsCantDoThatDefault(lst) {
		if(!lst.ofKind(Collection)) lst = [ lst ];
		return('{You/He} can\'t do that with the
			<<playingCardsStringListerOr.makeSimpleList(lst)>>. ');
	}

	// General response for >DISCARD [object] when the object isn't
	// a card.
	playingCardsCantDiscardThat = '{You/He} can\'t discard that. '

	// Message for >DISCARD without any argument.
	playingCardsCantDiscardMustSpecify = '{You/He} must specify which
		card(s) {you/he} want{s} to discard.
			<.p>Examples:
			<.p>
			\n\t<<formatInlineCommand('discard 2s')>>
			\n\t<<formatInlineCommand('discard two of spades')>>
			\n\t<<formatInlineCommand('discard 2s, 3h')>>
			<.p> '

	// Actor trying to do something with their cards but they're not
	// holding them.
	playingCardsCantUseHandNotHolding = '{You/He} can\'t do anything with {your/his} cards because {you/he} {are}n\'t holding them. '

	playingCardsCantUseSingleCard = '{You/He} can\'t do anything with the individual
		cards. '
	playingCardsCantTakeSingleCard = '{You/He} can\'t take individual cards.  Maybe
		try dealing a hand instead? '

	playingCardsCantUseNoHand = '{You/he} haven\'t been dealt a hand. '

	playingCardsCantShuffleThat = '{You/He} can\'t shuffle that. '
	playingCardsOkayShuffle = '{You/He} shuffle{s} the cards. '

	playingCardsCantDealThat = '{You/He} can only deal playing cards. '
	playingCardsCantDealNotDeck = '{You/He} can\'t deal any cards because
		{you/he} don\'t have the full deck. '
	playingCardsCantDealNoCount = 'How many cards do{es} {you/he} want to deal?'
	playingCardsCantDealThatManyCards(n, m) {
		return('{You/He} can\'t deal <<spellInt(n)>> cards because there are only <<spellInt(m)>> total cards in the deck. ');
	}
	playingCardsCantDealNoCardsLeft = '{You/He} can\'t deal any cards because there
		aren\'t any left in the deck. '
	playingCardsCantDealNotEnoughCards(n) {
		if(n == 1)
			return(playingCardsCantDealNoCardsLeft);
		return('{You/He} can\'t deal <<spellInt(n)>> cards because there aren\'t that many left in the deck.  The deck will have to be shuffled first. ');
	}
	playingCardsOkayDeal(n, m) {
		return('{You/He} deal{s} <<spellInt(n)>> card<<((n > 1) ? 's' : '')>><<((m == 1) ? '' : ' to each player')>>. ');
	}

	playingCardsOkayDiscard(lst) {
		if(!lst.ofKind(Collection)) lst = [ lst ];
		if(lst.length > 1) {
			return('{You/He} discard{s} <<spellInt(lst.length)>> cards: <<stringLister.makeSimpleList(lst)>>. ');
		} else {
			return('{You/He} discard{s} one card: <<stringLister.makeSimpleList(lst)>>. ');
		}
	}

	playingCardsFailedDiscard(lst) {
		if((lst != nil) && !lst.ofKind(Collection)) lst = [ lst ];
		return('{You/He} can\'t discard <<playingCardsStringListerOr.makeSimpleList(lst)>> because {you/he} {is}n\'t holding <<if(lst.length > 1)>> them<<else>>it<<end>>. ');
	}

	playingCardsOkayExamine(lst) {
		if(!lst.ofKind(Collection)) lst = [ lst ];
		return('There\'s nothing special about
			the <<stringLister.makeSimpleList(lst)>>. ');
	}

	playingCardsBadCard(lst) {
		if(!lst.ofKind(Collection)) lst = [ lst ];
		return('{You/He} see{s} no
			<<playingCardsStringListerOr.makeSimpleList(lst)>> here. ');
	}

	playingCardsCantTravelWithCards = '{You/He} can\'t leave the room with your playing cards.  Either drop or discard them if you want to leave. '

	playingCardsSummaryFailed = 'FIXME:  card summary failed'
;
