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

#include "personalThing.h"
#ifndef PERSONAL_THING_H
#error "This module requires the personalThing module."
#error "https://github.com/diegesisandmimesis/personalThing"
#error "It should be in the same parent directory as this module.  So if"
#error "playingCards is in /home/user/tads/playingCards, then personalThing"
#error "should be in /home/user/tads/personalThing ."
#endif // PERSONAL_THING_H

#ifndef DefineIActionSub
#define DefineIActionSub(name, cls) \
	DefineAction(name, cls) \

#endif // DefineIActionSub

#define DefinePlayingCardIAction(name) \
	DefineIActionSub(name, PlayingCardIAction)

#define DefinePlayingCardTAction(name) \
	DefineTActionSub(name, PlayingCardTAction)

#define PLAYING_CARDS_H
