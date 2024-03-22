#charset "us-ascii"
//
// playingCards.t
//
//	A TADS3/adv3 module implementing playing cards.
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

// Base object class for the module.
class PlayingCardsObject: Syslog syslogID = 'PlayingCards';

// Base playing card class.
// This is an abstract class for individual cards.  Intended to be
// extended by subclassing for each particular type of cards (standard
// 52-card playing cards, tarot cards, and so on).
class PlayingCard: PlayingCardsObject
	rank = nil		// the pip value of the card
	suit = nil		// the card's suit
	index = nil

	cardType = nil		// reference to the PlayingCards instance for
				// our "type"

	construct(r?, s?, idx?) {
		rank = r;
		suit = s;
		index = idx;
	}

	// Returns boolean true of the arg is a playing card and its
	// rank and suit equal ours.
	equals(c) {
		if((c == nil) || !c.ofKind(PlayingCard))
			return(nil);
		return((c.suit == suit) && (c.rank == rank));
	}

	// Returns the long and short names.  For example "two of clubs"
	// and "2C", respectively.
	getLongName() { return(cardType ? cardType.getLongName(self) : nil); }
	getShortName() { return(cardType ? cardType.getShortName(self) : nil); }
;

class PlayingCards: MultiLoc, Vaporous, PlayingCardsObject
	cardClass = PlayingCard		// PlayingCard class our cards use

	suitShort = perInstance([])	// single letter suit names
	suitLong = perInstance([])	// single word suit names
	rankShort = perInstance([])	// single number/letter rank
	rankLong = perInstance([])	// single word rank
	otherRank = perInstance([])	// rank for "other" cards
	otherShort = perInstance([])	// single word name of "other" cards
	otherLong = perInstance([])	// full name of "other" cards

	rankAndSuitRegex = nil		// compiled regex for rank and suit
	otherRegex = nil		// compiled regex for "other" cards

	// Set up our vocabulary to catch all plausible card descriptions
	// (for cards of our card class).
	initializeVocab() {
		local txt;

		inherited();

		// Set up weak tokens.
		txt = new StringBuffer();
		txt.append(rankShort.join(' '));
		txt.append(rankLong.join(' '));
		weakTokens = toString(txt).split(' ');

		// Add the suit names as nouns.
		suitShort.forEach(function(o) {
			cmdDict.addWord(self, o, &noun);
		});
		suitLong.forEach(function(o) {
			cmdDict.addWord(self, o, &noun);
		});

		// Add the short names ("2C", "3H", and so on) as nouns.
		suitShort.forEach(function(s) {
			rankShort.forEach(function(r) {
				cmdDict.addWord(self, '<<r>><<s>>', &noun);
			});
		});

		// Add vocabulary of "other" cards ("Joker", the major
		// arcana in a tarot deck, and so on).
		otherShort.forEach(function(o) {
			cmdDict.addWord(self, o, &noun);
		});
		otherLong.forEach(function(o) {
			o.split(' ').forEach(function(w) {
				if(w.toLower() == 'the')
					return;
				cmdDict.addWord(self, w, &noun);
			});
		});
	}

	// Build a regex to capture the rank and suit from a string.
	initRankAndSuitRegex() {
		local txt;

		txt = new StringBuffer();
		txt.append('(THE[ ]+){0,1}(');
		txt.append(rankShort.join('|'));
		txt.append('|');
		txt.append(rankLong.join('|'));
		txt.append('){1}([ ]+OF[ ]+){0,1}(');
		txt.append(suitShort.join('|'));
		txt.append('|');
		txt.append(suitLong.join('|'));
		txt.append('){1}');
		txt = toString(txt).toUpper();

		rankAndSuitRegex = new RexPattern(txt);
	}

	initOtherRegex() {
		local txt, v;

		v = new Vector(otherShort);
		otherLong.forEach(function(o) {
			o = o.split(' ');
			v.appendUnique(o);
		});
		txt = new StringBuffer();
		txt.append('(THE[ ]+){0,1}(');
		txt.append(v.join('|'));
		txt.append('){1}');
		txt = toString(txt).toUpper();

		otherRegex = new RexPattern(txt);
	}

	getLongRank(idx) { return(rankLong[idx]); }
	getShortRank(idx) { return(rankShort[idx]); }

	getLongSuit(idx) { return(suitLong[idx]); }
	getShortSuit(idx) { return(suitShort[idx]); }

	// Try various ways to parse a string as a card name, returning
	// a PlayingCard instance of the match, if any.
	getCardFromString(id) {
		local m;

		// ID can't be nil.
		if(id == nil)
			return(nil);

		// Convert the ID to upper case.
		id = id.toUpper();

		if((m = matchRankAndSuit(id)) != nil)
			return(m);

		if((m = matchOther(id)) != nil)
			return(m);

		return(nil);
	}

	// Returns the matching card object if the argument is a string
	// describing a rank-and-suit card ("two of clubs", "3H", and so on).
	matchRankAndSuit(id) {
		local m;

		if(rankAndSuitRegex == nil)
			initRankAndSuitRegex();

		m = id.findAll(rankAndSuitRegex,
			function(match, index, art, rank, conj, suit) {
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
			return(cardClass.createInstance(rank, suit));
		});

		if((m != nil) && (m.length > 0))
			return(m[1]);

		return(nil);
	}

	// Returns a card object if the argument is a string describing
	// an "other" card in the deck ("Joker", "Justice", "The High
	// Priestess", and so on).
	matchOther(id) {
		local m;

		if(otherRegex == nil)
			initOtherRegex();

		m = id.findAll(otherRegex,
			function(match, index, art, other) {
			// If we didn't match a rank and suit, we're stumped.
			if(other == nil)
				return(nil);

			if((other = getOther(other)) == nil)
				return(nil);

			// Return a PlayingCard instance of the given
			// rank and suit.
			return(cardClass.createInstance(other,
				suitShort.length + 1));
		});

		if((m != nil) && (m.length > 0))
			return(m[1]);

		return(nil);
	}

	// Try to figure out what rank the passed ID corresponds to.
	// This is going to be from player input, and will work for
	// figuring out "2H" and "two of hearts", for example.
	getRank(id) {
		local idx, tmp;

		if(id == nil)
			return(nil);

		tmp = id.toUpper();
		if((idx = rankShort.indexOf(tmp)) != nil)
			return(idx);

		tmp = id.toLower();
		if((idx = rankLong.indexOf(tmp)) != nil)
			return(idx);

		if((idx = toInteger(id)) == nil)
			return(nil);

		if((idx < 1) || (idx > rankShort.length))
			return(nil);

		return(idx);
	}

	// The same as above, only for suits instead of ranks
	getSuit(id) {
		local idx, tmp;

		if(id == nil)
			return(nil);

		tmp = id.toUpper();
		if((idx = suitShort.indexOf(tmp)) != nil)
			return(idx);

		tmp = id.toLower();
		if((idx = suitLong.indexOf(tmp)) != nil)
			return(idx);

		return(nil);
	}

	// As above, but tries to match the "other" cards.
	getOther(id) {
		local idx, tmp;

		if(id == nil)
			return(nil);

		tmp = id.toLower();
		if((idx = otherShort.indexOf(tmp)) != nil)
			return(idx);

		tmp = id.toTitleCase();
		if((idx = otherLong.indexOf(tmp)) != nil)
			return(idx);

		return(nil);
	}

	// Given a (probably player-supplied) text description of a card,
	// try to figure out what card is named and return a PlayingCard
	// instance of it
	getCard(id) {
		if(id == nil)
			return(nil);

		// if our "ID" is already a PlayingCard instance, we're done
		if(id.ofKind(PlayingCard))
			return(id);

		// try to convert the ID into a card instance
		return(getCardFromString(id));
	}

	// Given a PlayingCard object, return the short name ("2H") for it
	getShortName(card) {
		local r, s;

		card = getCard(card);

		if(card.suit <= suitShort.length) {
			r = rankShort[card.rank];
			s = suitShort[card.suit];
			return(r + s);
		} else {
			return(otherShort[card.rank]);
		}
	}

	// Given a PlayingCard object, return the long name ("two of hearts")
	// for it
	getLongName(card) {
		local r, s;

		card = getCard(card);

		if(card.suit <= suitLong.length) {
			r = rankLong[card.rank];
			s = suitLong[card.suit];
			return(r + ' of ' + s);
		} else {
			return(otherLong[card.rank]);
		}
	}
;
