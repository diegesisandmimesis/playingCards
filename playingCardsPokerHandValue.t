#charset "us-ascii"
//
// playingCardsPokerHandValue.t
//
//	Data structure for holding a poker hand value.
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

// Datatype for evaluated hand value.
class PokerHandValue: PlayingCardsObject
	value = nil	// abstract value of hand, number from 0 to 7462
	rank = nil	// ordinal indicating kind of hand, from 1 to 9 

	// Not set by evaluator, used by PokerHand.getRankDetails.  Identifies
	// the card rank (not hand rank) of the cards that contributed to
	// the hand rank.  So if you have a pair of 8s, high would be 9 (due
	// to the card ranks counting from 2) and over and suit would be nil.
	// A full house of aces over 8s would have high = 16 (ace) and
	// over = 9 (8), and suit would be nil.  An 8-high straight flush
	// in clubs would have high = 9, and suit would be 4 (because clubs are
	// 4 in our arbitrary suit ordering, as defined in drawPokerDeck.t).
	high = nil	// highest card(s) contributing to rank
	over = nil	// next-highest card(s) contributing to rank
	suit = nil	// suit if a flush/straight flush

	// Magic numbers.  These are the breakpoints for the different kinds
	// of hands, by numeric value (as computed by the hand evaluator).
	// These correspond to the hand rank names below.
	handRankValue = static [
		-1,
		10,
		166,
		322,
		1599,
		1609,
		2467,
		3325,
		6185,
		7462
	]

	// Names for the hand types.
	handRankName = static [
		'straight flush',	// < 10
		'four of a kind',	// < 166
		'full house',		// < 322
		'flush',		// < 1599
		'straight',		// < 1609
		'three of a kind',	// < 2467
		'two pair',		// < 3325
		'one pair',		// < 6185
		'just a high card',	// < 7462
		'placeholder'		// not used
	]

	// All we need is a value
	construct(v?) { value = (v ? v : nil); }

	// Determines the numeric rank of this hand type for our value.
	// That is, based on the numeric value (returned by the hand evaluator),
	// we figure out if we're two pair, a full house, or whatever.  The
	// return value is an integer, corresponding to an index in the
	// hand rank name array above.
	getRank() {
		local i;

		if(rank != nil)
			return(rank);
		
		if((value == nil) || (value < 0))
			return(nil);

		i = handRankValue.length();
		while(value <= handRankValue[i]) {
			i -= 1;
		}

		rank = i;

		return(rank);
	}

	// Get the "simple" name for our rank ("one pair", "two pair", and
	// so on).
	getRankType() { return(handRankName[getRank()]); }

	// Computes the details of the hand ranking.  This is entirely for
	// reporting.  If we've got four of a kind, we figure out four of
	// what, if it's a full house, we figure out what over what, and so
	// on.
	// Arg needs to be a five-element array of PlayingCard instances.
	computeRankDetails(cards) {
		local i, len, rankArray, suitArray, v, w;

		rankArray = new Vector(13);
		rankArray.fillValue(0, 1, 13);
		suitArray = new Vector(4);
		suitArray.fillValue(0, 1, 4);
		cards.forEach(function(o) {
			rankArray[o.rank] += 1;
			suitArray[o.suit] += 1;
		});
		v = nil;
		w = nil;
		len = rankArray.length();
		switch(getRank()) {
			case 1:		// straight flush
			case 5:		// straight
				for(i = len; i > 0 && !v; i--)
					if(rankArray[i] > 0) v = i;
				high = v;
				break;
			case 2:		// 4 of a kind
				for(i = 1; i <= len && !v; i++)
					if(rankArray[i] == 4) v = i;
				high = v;
				break;
			case 3:		// full house
				for(i = 1; i <= len && (!v || !w); i++) {
					if(rankArray[i] == 3) v = i;
					if(rankArray[i] == 2) w = i;
				}
				high = v;
				over = w;
				break;
			case 4:		// flush
				for(i = 1; i <= suitArray.length(); i++)
					if(suitArray[i] > 0) v = i;
				suit = v;
				break;
			case 6:		// 3 of a kind
				for(i = 1; i <= len && !v; i++)
					if(rankArray[i] == 3) v = i;
				high = v;
				break;
			case 7:		// 2 pair
				for(i = len; i > 0 && (!v || !w); i--) {
					if(rankArray[i] == 2) {
						if(!v) v = i;
						else w = i;
					}
				}
				high = v;
				over = w;
				break;
			case 8:		// 1 pair
				for(i = len; i > 0 && !v; i--) {
					if(rankArray[i] == 2) v = i;
				}
				high = v;
				break;
			case 9:		// nothing
				for(i = len; i > 0 && !v; i--) {
					if(rankArray[i] == 1) v = i;
				}
				high = v;
				break;
		}
	}

	// Return the full description of the hand rank "nothing, ace high",
	// "a pair of twos", and so on.
	getDescription(cards) {
		local c, type;

		// Compute the rand details.
		computeRankDetails(cards);

		// Get a reference to the PlayingCards instance our card
		// type uses.
		c = cards[1].cardType;

		// The basic hand description.
		type = getRankType();

		switch(rank) {
			case 1:		// straight flush
				return('a ' + c.getLongRank(high)
					+ '-high ' + type);
			case 2:		// 4 of a kind
				return('four ' + c.getLongRank(high) + 's');
			case 3:		// full house
				return('a ' + type + ', ' + c.getLongRank(high)
					+ 's over ' + c.getLongRank(over)
					+ 's');
			case 4:		// flush
				return('a ' + type);
			case 5:		// straight
				return('a ' + c.getLongRank(high)
					+ '-high ' + type);
			case 6:		// 3 of a kind
				return('three ' + c.getLongRank(high) + 's');
			case 7:		// 2 pair
				return('two pair, ' + c.getLongRank(high)
					+ 's and ' + c.getLongRank(over) + 's');
			case 8:		// 1 pair
				return('a pair of ' + c.getLongRank(high)
					+ 's');
			case 9:		// nothing
				return('nothing, ' + c.getLongRank(high)
					+ ' high');
			default:
				return('unknown');
		}
	}
;
