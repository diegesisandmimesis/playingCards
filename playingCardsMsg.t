#charset "us-ascii"
//
// playingCardsMsg.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

modify playerActionMessages
	formatInlineCommand(txt) {
		return('<b>&gt;<<toString(txt).toUpper()>></b>');
	}
	formatCommand(txt) {
		return('<.p>\n\t<<formatInlineCommand(txt)>><.p> ');
	}

	invalidCardName(n) {
		return('The story tried to interpret <q><<toString(n)>></q> as
			the name of a card but failed. ');
	}

	cantDiscardThat = '{You/He} can\'t discard that. '
	cantDiscardMustSpecify = '{You/He} must specify which card(s)
		{you/he} want{s} to discard.
			<.p>Examples:
			<.p>
			\n\t<<formatInlineCommand('discard 2s')>>
			\n\t<<formatInlineCommand('discard two of spades')>>
			\n\t<<formatInlineCommand('discard 2s, 3h')>>
			<.p> '

	cantUseHandNotHolding = '{You/He} can\'t do anything with {your/his}
		cards because {you/he} {are}n\'t holding them. '

	cantNoCard(txt) {
		return('{You/He} see{s} no <<txt>> here. ');
	}

	cantUseSingleCard = '{You/He} can\'t do anything with the individual
		cards. '
	cantTakeSingleCard = '{You/He} can\'t take individual cards.  Maybe
		try dealing a hand instead? '

	cantUseNoHand = '{You/he} haven\'t been dealt a hand. '

	cantShuffleThat = '{You/He} can\'t shuffle that. '
	okayShuffle = '{You/He} shuffle{s} the cards. '

	cantDealThat = '{You/He} can only deal playing cards. '
	cantDealNotDeck = '{You/He} can\'t deal any cards because
		{you/he} don\'t have the full deck. '
	cantDealNoCount = 'How many cards do{es} {you/he} want to deal?'
	cantDealNotThatManyCards(n, m) {
		return('{You/He} can\'t deal <<spellInt(n)>> cards because
			there are only <<spellInt(m)>> total cards in the
			deck. ');
	}
	cantDealNotEnoughCards(n) {
		return('{You/He} can\'t deal <<spellInt(n)>> cards because
			there aren\'t that many left in the deck.  The deck
			will have to be shuffled first. ');
	}
	okayDeal(n) {
		return('{You/He} deal{s} <<spellInt(n)>> cards. ');
	}

	okayDiscard(id) {
		return('{You/He} discard{s} the <<id>>. ');
	}

	okayDiscardList(lst) {
		return('{You/He} discard{s} <<spellInt(lst.length)>> cards:
			<<stringLister.makeSimpleList(lst)>>. ');
	}
	failedDiscardList(lst) {
		return('{You/He} can\'t discard
			<<stringLister.makeSimpleList(lst)>> because
			{you/he} {is}n\'t holding <<if(lst.length > 1)>>
			them<<else>>it<<end>>. ');
	}
;
