#charset "us-ascii"
//
// playingCards.t
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

// Module ID for the library
playingCardsModuleID: ModuleID {
        name = 'Playing Cards Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

class PlayingCardsObject: Syslog syslogID = 'PlayingCards';

class PlayingCard: PlayingCardsObject
	rank = nil
	suit = nil
	val = nil
	index = nil

	primes = static [ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41 ]

	construct(r?, s?, idx?) {
		rank = r;
		suit = s;
		index = idx;
	}

	computeVal() {
		local i, k, s;

		k = rank - 1;
		s = 0x8000;
		for(i = 1; i < (5 - suit); i++, s >>= 1);
		val = primes[rank] | (k << 8) | s | (1 << (16 + k));
	}

	equals(c) {
		if((c == nil) || !c.ofKind(PlayingCard))
			return(nil);
		return((c.suit == suit) && (c.rank == rank));
	}
;

playingCardNames: MultiLoc, Vaporous, PlayingCardsObject
	'
	(2) (3) (4) (5) (6) (7) (8) (9) (10) (j) (k) (q) (of)
	(jack) (queen) (king) (ace)
	s h d c
	spades hearts diamonds clubs
	2s 3s 4s 5s 6s 7s 8s 9s 10s js qs ks as
	2h 3h 4h 5h 6h 7h 8h 9h 10h jh qh kh ah
	2d 3d 4d 5d 6d 7d 8d 9d 10d jd qd kd ad
	2c 3c 4c 5c 6c 7c 8c 9c 10c jc qc kc ac
	pokerCard'
	'playing card'

	// Constants
	shortSuit = static [ 'S', 'H', 'D', 'C' ]
	symbolSuit = static [ '\u2660', '\u2665', '\u2666', '\u2663' ]
	longSuit = static [ 'spades', 'hearts', 'diamonds', 'clubs' ]
	shortRank = static [ '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J',
		'Q', 'K', 'A' ]
	longRank = static [ 'two', 'three', 'four', 'five', 'six', 'seven',
		'eight', 'nine', 'ten', 'jack', 'queen', 'king', 'ace' ]

	// Hooks for macros.
	getShortRank(v) { return(shortRank[v]); }
	getLongRank(v) { return(longRank[v]); }

	// Try to figure out what rank the passed ID corresponds to.
	// This is going to be from player input, and will work for
	// figuring out "2H" and "two of hearts", for example.
	getRank(id) {
		local idx, tmp;

		if(id == nil)
			return(nil);

		tmp = id.toUpper();
		if((idx = shortRank.indexOf(tmp)) != nil)
			return(idx);

		tmp = id.toLower();
		if((idx = longRank.indexOf(tmp)) != nil)
			return(idx);

		if((idx = toInteger(id)) == nil)
			return(nil);

		if((idx < 1) || (idx > 14))
			return(nil);

		return(idx);
	}

	// The same as above, only for suits instead of ranks
	getSuit(id) {
		local idx, tmp;

		if(id == nil)
			return(nil);

		tmp = id.toUpper();
		if((idx = shortSuit.indexOf(tmp)) != nil)
			return(idx);

		tmp = id.toLower();
		if((idx = longSuit.indexOf(tmp)) != nil)
			return(idx);

		return(nil);
	}

	// Given a (probably player-supplied) text description of a card,
	// try to figure out what card is named and return a PlayingCard
	// instance of it
	getCard(id) {
		if(id == nil)
			return(nil);

		// if our "id" is already a PlayingCard instance, we're done
		if(id.ofKind(PlayingCard))
			return(id);

		// try to convert the id into a card instance
		return(getCardFromString(id));
	}

	// Try various ways to parse a string as a card name, returning
	// a PlayingCard instance of the match, if any.
	getCardFromString(id) {
		local m;

		// ID can't be nil.
		if(id == nil)
			return(nil);

		// Convert the ID to upper case.
		id = id.toUpper();

		// Big ol' ugly regex of various ways to write out a card name.
		m = id.findAll(R'(2|3|4|5|6|7|8|9|10|J|Q|K|A|JACK|QUEEN|KING|ACE){1}([ ]+OF[ ]+){0,1}(S|H|D|C|SPADES|HEARTS|DIAMONDS|CLUBS){1}', function(match, index, rank, conj, suit) {
			// If we didn't match a rank and suit, we're stumped.
			if((rank == nil) || (suit == nil))
				return(nil);

			// Canonicalize the rank and suit.
			rank = getRank(rank);
			suit = getSuit(suit);

			// ...or die trying.
			if((rank == nil) || (suit == nil))
				return(nil);

			// Return a PlayingCard instance of the given
			// rank and suit.
			return(new PlayingCard(rank, suit));
		});

		// We couldn't convert the string into anything.
		if((m == nil) || (m.length() < 1))
			return(nil);

		// Should never happen.
		return(m[1]);
	}

	// Given a PlayingCard object, return the short name ("2H") for it
	getShortName(card) {
		local r, s;

		card = getCard(card);

		r = shortRank[card.rank];
		s = shortSuit[card.suit];

		return(r + s);
	}

	// Given a PlayingCard object, return the long name ("two of hearts")
	// for it
	getLongName(card) {
		local r, s;

		card = getCard(card);

		r = longRank[card.rank];
		s = longSuit[card.suit];

		return(r + ' of ' + s);
	}
;
