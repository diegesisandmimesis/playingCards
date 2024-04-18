#charset "us-ascii"
//
// playingCardsVocab.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

class PlayingCardVocab: MultiLoc, Fixture, Vaporous, PlayingCardsObject
	initialLocationClass = Room

	playingCardsMatchTurn = nil
	playingCardsMatchList = perInstance(new Vector())

	minSummaryLength = 1

	_playingCardDataTable = perInstance(new LookupTable())

	hideFromAll(action) { return(true); }

	matchNameCommon(origTokens, adjustedTokens) {
		local txt;

		if(playingCardsMatchTurn != libGlobal.totalTurns) {
			playingCardsMatchList.setLength(0);
			playingCardsMatchTurn = libGlobal.totalTurns;
		}

		txt = new Vector();
		adjustedTokens.forEach(function(o) {
			if(dataTypeXlat(o) != TypeSString)
				return;
			txt.appendUnique(o);
		});

		if(txt.length == 1)
			playingCardsMatchList.append(origTokens[1][1]);
		else
			playingCardsMatchList.append(txt.join(' '));

		return(inherited(origTokens, adjustedTokens));
	}

	// Returns the first card name mentioned in the current action's
	// tokens.
	// The list is populated for each action by matchNameCommon().
	getFirstPlayingCardMatch() {
		if((playingCardsMatchList.length < 1)
			|| (playingCardsMatchTurn != libGlobal.totalTurns))
			return(nil);
		return(playingCardsMatchList[1]);
	}

	// Clears the first entry in the match list for this action.
	clearFirstPlayingCardMatch() { playingCardsMatchList.splice(1, 1); }

	clearPlayingCardData() {
		_playingCardDataTable.forEachAssoc(function(k, v) {
			if(v == nil)
				return;
			v.setLength(0);
		});
	}

	getPlayingCardData(id) { return(_playingCardDataTable[id]); }

	rememberPlayingCardData(key, txt) {
		if(_playingCardDataTable[key] == nil)
			_playingCardDataTable[key] = new Vector();
		_playingCardDataTable[key].append(txt);
		gAction.callAfterActionMain(self);
	}

	playingCardError(msg, data?, key?) {
		if(data)
			reportFailure(msg, data);
		else
			reportFailure(msg);
		if(key)
			rememberPlayingCardData(key, data);
		clearFirstPlayingCardMatch();
		exit;
	}

	afterActionMain() {
		if(gAction.dobjList_.length < minSummaryLength) {
			clearPlayingCardData();
			return;
		}
		gTranscript.summarizeAction(
			function(x) {
				return(x.action_ == gAction);
			},
			function(vec) {
				return(summarizePlayingCardActions(vec));
			}
		);
		clearPlayingCardData();
	}

	summarizePlayingCardActions(vec) {
		return(playerActionMessages.playingCardsSummaryFailed);
	}
;
