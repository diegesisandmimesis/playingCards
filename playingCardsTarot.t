#charset "us-ascii"
//
// playingCardsTarot.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

class TarotCard: PlayingCard
	cardType = TarotCardType
	reversed = nil
;

class TarotCardType: PlayingCardType
	cardClass = TarotCard
	deckClass = TarotDeck

	suitShort = static [ 'S', 'C', 'P', 'W' ]
	suitLong = static [ 'swords', 'cups', 'pentacles', 'wands' ]

	rankShort = static [ 'A', '2', '3', '4', '5', '6', '7', '8', '9',
		'10', 'J', 'P', 'N', 'Q', 'K' ]
	rankLong = static [ 'ace', 'two', 'three', 'four', 'five', 'six',
		'seven', 'eight', 'nine', 'ten', 'page', 'knight', 'queen',
		'king' ]

	rankOther = static [ '0', 'I', 'II', 'III', 'IV', 'V', 'VI',
		'VII', 'VIII', 'IX', 'X', 'XI', 'XII', 'XIII', 'XIV',
		'XV', 'XVI', 'XVII', 'XVII', 'XIX', 'XX', 'XXI' ]
	otherShort = static [ 'fool', 'magician', 'priestess', 'empress',
		'emperor', 'hierophant', 'lovers', 'chariot', 'strength',
		'hermit', 'fortune', 'justice', 'hanged', 'death',
		'temperance', 'devil', 'tower', 'star', 'moon', 'sun',
		'judgement', 'world' ]
	otherLong =  static [ 'the fool', 'the magician', 'the high priestess',
		'the empress', 'the emperor', 'the hierophant', 'the lovers',
		'the chariot', 'strength', 'the hermit', 'wheel of fortune',
		'justice', 'the hanged man', 'death', 'temperance',
		'the devil', 'the tower', 'the star', 'the moon',
		'the sun', 'judgement', 'the world' ]

	getLongName(card) {
		local r, v;

		if((r = inherited(card)) == nil)
			return(nil);

		r = r.split(' ');
		v = new Vector(r.length);
		r.forEach(function(o) {
			v.append(o.substr(1, 1).toTitleCase()
				+ o.substr(2));
		});
		if(card.reversed == true)
			v.append('(reversed)');

		return(toString(v.join(' ')));
	}
;

class TarotDeck: CardDeck
	cardCount = 78
	suits = 4
	ranks = 14
	others = 22
	cardType = TarotCardType

	shuffle() {
		inherited();
		_deck.forEach(function(o) {
			if(_prng.random(1, 2) == 2)
				o.reversed = true;
		});
	}
;
