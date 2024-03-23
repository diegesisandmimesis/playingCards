#charset "us-ascii"
//
// playingCardsMsg.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

modify playerActionMessages
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
