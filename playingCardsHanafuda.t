#charset "us-ascii"
//
// playingCardsHanafuda.t
//
//	Incomplete hanafuda implementation.
//
//	Basic functionality works, but card naming is a little kludgy and
//	disambiguation between equivalent cards isn't handled.
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

#ifdef PLAYING_CARDS_HANAFUDA

class HanafudaCard: PlayingCard
	cardType = HanafudaCardType
;

class HanafudaCardType: PlayingCardType
	cardClass = HanafudaCard
	deckClass = HanafudaDeck

	suitShort = static [ '', '', '', '', '', '', '', '', '', '', '', '' ]
	suitLong = static [ '', '', '', '', '', '', '', '', '', '', '', '' ]

	rankShort = static [ '', '', '', '' ]
	rankLong = static [ '', '', '', '' ]

	fancyName = static [
		[ 'Crane and Sun', 'Red Poetry Ribbon (Pine)', 'Pine', 'Pine' ],
		[ 'Warbling White-Eye (Plum)', 'Red Poetry Ribbon (Plum)',
			'Plum', 'Plum' ],
		[ 'Curtain', 'Red Poetry Ribbon (Cherry)', 'Cherry', 'Cherry' ],
		[ 'Cuckoo (Wisteria)', 'Red Poetry Ribbon (Wisteria)',
			'Wisteria', 'Wisteria' ],
		[ 'Eight-Plank Bridge (Iris)', 'Red Poetry Ribbon (Iris)',
			'Iris', 'Iris' ],
		[ 'Butterfiles', 'Blue Poetry Ribbon (Peony)', 'Peony',
			'Peony' ],
		[ 'Boar', 'Red Poetry Ribbon (Clover)', 'Clover', 'Clover' ],
		[ 'Full Moon', 'Geese (Grass)', 'Grass', 'Grass' ],
		[ 'Sake Cup', 'Blue Poetry Ribbon (Chrysanthemum)',
			'Chrysanthemum', 'Chrysanthemum' ],
		[ 'Deer', 'Blue Poetry Ribbon (Maple)', 'Maple', 'Maple' ],
		[ 'Ono no Michikaze', 'Swallow (Willow)',
			'Red Poetry Ribbon (Willow)', 'Lightning' ],
		[ 'Phoenix', 'Paulownia', 'Paulownia', 'Paulownia' ]

	]

	getShortName(card) { return(getLongName(card)); }
	getLongName(card) { return(fancyName[card.suit][card.rank]); }

	initializeVocab() {
		local ar, v;

		inherited();
		v = new Vector();
		fancyName.forEach(function(o) {
			o.forEach(function(n) {
				ar = n.split(' ');
				ar.forEach(function(p) {
					v.appendUnique(p.toLower());
				});
			});
		});
		v.forEach(function(o) {
			cmdDict.addWord(self, o, &noun);
		});
	}

	getSuit(id) {
		local idx, j, tmp;

		if(id == nil)
			return(nil);

		tmp = id.toLower();

		for(idx = 1; idx <= fancyName.length; idx++) {
			for(j = 1; j <= fancyName[idx].length; j++) {
				if(tmp == fancyName[idx][j].toLower())
					return(idx);
			}
		}

		return(nil);
	}

	getRank(id) {
		local idx, j, tmp;

		if(id == nil)
			return(nil);

		tmp = id.toLower();

		for(idx = 1; idx <= fancyName.length; idx++) {
			for(j = 1; j <= fancyName[idx].length; j++) {
				if(tmp == fancyName[idx][j].toLower())
					return(j);
			}
		}

		return(nil);
	}

	matchOther(id) { return(nil); }

	matchRankAndSuit(id) {
		local r, s;

		r = getRank(id);
		s = getSuit(id);
		if((r == nil) || (s == nil))
			return(nil);

		return(cardClass.createInstance(r, s));
	}
;

class HanafudaDeck: CardDeck
	cardCount = 48
	suits = 12
	ranks = 4
	cardType = HanafudaCardType
;

#endif // PLAYING_CARDS_HANAFUDA
