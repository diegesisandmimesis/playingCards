//
// playingCards.h
//

// Uncomment to enable debugging options.
//#define __DEBUG_PLAYING_CARDS

#include "syslog.h"
#ifndef SYSLOG_H
#error "This module requires the syslog module."
#error "https://github.com/diegesisandmimesis/syslog"
#error "It should be in the same parent directory as this module.  So if"
#error "playingCards is in /home/user/tads/playingCards, then"
#error "syslog should be in /home/user/tads/syslog ."
#endif // SYSLOG_H

#define gPlayingCard(txt) (playingCardNamed.getCard(txt))
#define gPlayingCardShortName(card) (playingCardNames.getShortName(card))
#define gPlayingCardLongName(card) (playingCardNames.getLongName(card))
#define gPlayingCardShortRank(idx) (playingCardNames.getShortRank(idx))
#define gPlayingCardLongRank(idx) (playingCardNames.getLongRank(idx))

#define PLAYING_CARDS_H
