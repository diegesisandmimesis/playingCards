#charset "us-ascii"
//
// playingCardsMsg.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

modify playerActionMessages
	cantDiscardThat = '{You/He} can\'t discard that. '

	cantExamineNoCard = '{You/He} can\'t see that here. '

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
;
