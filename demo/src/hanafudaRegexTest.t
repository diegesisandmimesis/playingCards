#charset "us-ascii"
//
// hanafudaRegexTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the playingCards library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f hanafudaRegexTest.t3m
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
		'crane and sun',
		'cherry',
		'iris',
		'Full Moon',
		'Ono no Michikaze'
	]

	newGame() {
		local c, p;

		p = new HanafudaCardType();
		_tests.forEach(function(o) {
			if((c = p.getCardFromString(o)) == nil) {
				"failed to resolve <q><<o>></q>\n ";
				return;
			}
			"<<o>> -> <<c.getLongName()>>\n ";
		});
	}
;
