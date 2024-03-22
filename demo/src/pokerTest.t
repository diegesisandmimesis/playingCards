#charset "us-ascii"
//
// pokerTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the playingCards library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f pokerTest.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

versionInfo: GameID;
gameMain: GameMainDef
	players = 2

	newGame() {
		local deck, l, i;

		deck = new PokerDeck();
		deck.shuffle();
		l = deck.deal(5, players);
		for(i = 1; i <= players; i++) {
			"Player <<toString(i)>>\n ";
			l[i].forEach(function(o) {
				"\t<<toString(o.getLongName())>>
					<<toString(o.uniqueValue)>>\n ";
			});
		}
	}
;
