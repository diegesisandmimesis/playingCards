#charset "us-ascii"
//
// playingCardsMsg.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

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
	invalidCardName(n) {
		return('The story tried to interpret <q><<toString(n)>></q> as the name of a card but failed. ');
	}

	// Generic failure message
	cantDoThatDefault(id) {
		return('{You/He} can\'t do that with the <<id>>. ');
	}
	cantDoThatDefaultList(lst) {
		return('{You/He} can\'t do that with the
			<<stringLister.makeSimpleList(lst)>>. ');
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

	cantUseHandNotHolding = '{You/He} can\'t do anything with {your/his} cards because {you/he} {are}n\'t holding them. '

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
		return('{You/He} can\'t deal <<spellInt(n)>> cards because there are only <<spellInt(m)>> total cards in the deck. ');
	}
	cantDealNoCardsLeft = '{You/He} can\'t deal any cards because there
		aren\'t any left in the deck. '
	cantDealNotEnoughCards(n) {
		if(n == 1)
			return(cantDealNoCardsLeft);
		return('{You/He} can\'t deal <<spellInt(n)>> cards because there aren\'t that many left in the deck.  The deck will have to be shuffled first. ');
	}
	okayDeal(n, m) {
		return('{You/He} deal{s} <<spellInt(n)>> card<<((n > 1) ? 's' : '')>><<((m == 1) ? '' : ' to each player')>>. ');
	}

	okayDiscard(id) {
		return('{You/He} discard{s} the <<id>>. ');
	}

	okayDiscardList(lst) {
		if(lst.length > 1) {
			return('{You/He} discard{s} <<spellInt(lst.length)>> cards: <<stringLister.makeSimpleList(lst)>>. ');
		} else {
			return('{You/He} discard{s} one card: <<stringLister.makeSimpleList(lst)>>. ');
		}
	}
	failedDiscardList(lst) {
		return('{You/He} can\'t discard <<stringLister.makeSimpleList(lst)>> because {you/he} {is}n\'t holding <<if(lst.length > 1)>> them<<else>>it<<end>>. ');
	}

	okayExamineCard(card) {
		return('There\'s nothing special about the
			<<card.getLongName()>>. ');
	}
	okayExamineCardList(lst) {
		return('There\'s nothing special about
			the <<stringLister.makeSimpleList(lst)>>. ');
	}
	cantExamineCardList(lst) {
		return('{You/He} see{s} no
			<<stringLister.makeSimpleList(lst)>> here. ');
	}
	cantParseNames(lst) {
		return('The story tried to interpret <<stringLister.makeSimpleList(lst)>> as the <<if(lst.length > 1)>>names of cards<<else>> name of a card<<end>> but failed. ');
	}
;
