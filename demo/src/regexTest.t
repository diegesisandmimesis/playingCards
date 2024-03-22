#charset "us-ascii"
//
// regexTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the playingCards library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f regexTest.t3m
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
	_tests = static [
		'two of hearts',
		'2H',
		'2 of h',
		'two of h',
		'joker'
	]

	newGame() {
		local c;

		_tests.forEach(function(o) {
			if((c = standardPlayingCards.getCardFromString(o)) == nil) {
				"failed to resolve <q><<o>></q>\n ";
				return;
			}
			"<<o>> -> <<c.getLongName()>>\n ";
		});
	}
;
