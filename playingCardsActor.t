#charset "us-ascii"
//
// playingCardsActor.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "playingCards.h"

modify Actor
	playingCardsHand = nil
	playingCardsHandClass = PlayingCardsHand

	// Get the actor's card hand.
	getPlayingCardsHand(deck?) {
		local r;

		// If the deck we're looking for isn't specified, try
		// to check some defaults.
		if(deck == nil) {
			// First, see if exactly one relevant hand is in
			// our current inventory.  If so, use it.
			if((r = getPlayingCardsHandInInventory()) != nil)
				return(r);

			// Nope, set a default.
			deck = 'default';
		}

		if(playingCardsHand == nil)
			playingCardsHand = new LookupTable();

		if(playingCardsHand[deck] == nil) {
			playingCardsHand[deck] = getPlayingCardsHandClass()
				.createInstance();
			playingCardsHand[deck].owner = self;
		}

		return(playingCardsHand[deck]);
	}

	// Try to figure out which hand object to use based on which one(s)
	// are currently in the actor's inventory.
	getPlayingCardsHandInInventory(cls?) {
		local l0, l1;

		// Return vector, no longer than the inventory size.
		l0 = new Vector(contents.length);

		// If we haven't been told to match a particular hand class,
		// use our default one.
		if(cls == nil)
			cls = getPlayingCardsHandClass();

		// Go through and make a list of everything in the inventory
		// that matches the class.
		contents.forEach(function(o) {
			if(o.ofKind(cls))
				l0.append(o);
		});

		// If we have no candidates, fail.
		if(l0.length < 1)
			return(nil);

		// If we have exactly one candidate, use it.
		if(l0.length == 1)
			return(l0[1]);

		// If we make it here, we have multiple candidates.  So
		// we filter agan:
		// New vector (no bigger than the last one).
		l1 = new Vector(l0.length);

		// Go through each element of the first list...
		l0.forEach(function(o) {
			local d;

			// ...make sure the hand object has a deck defined.
			if((d = l0._deck) == nil)
				return;

			// ...and if so, see if the deck is in the same
			// room as the actor is at the moment.  If so,
			// add it to the new list.
			if(d.getOutermostRoom() == self.getOutermostRoom())
				l1.append(o);
		});

		// If we have exactly one candidate in the new list, use
		// it.
		if(l1.length == 1)
			return(l1[1]);

		// Admit ignominious defeat.
		return(nil);
	}

	getPlayingCardsHandClass() { return(playingCardsHandClass); }

	hasPlayingCard(id, deck?) {
		return(getPlayingCardsHand(deck).hasCard(id));
	}
;
