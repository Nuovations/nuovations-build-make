/*
 *    Copyright (c) 2008-2023 Nuovation System Designs, LLC
 *    All rights reserved.
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

/**
 *    @file
 *      This file implements "multi-threaded monte". This is a
 *      contrived version of the traditional three-card monte to
 *      demonstrate multi-threaded operation using POSIX threads and
 *      debugging in a multi-threaded environment. In this version of
 *      "monte", you don't get to see how the cards get moved about on
 *      the "table", you use the debugger to do that.
 *
 *      The game works by having each thread draw a card and one of
 *      the threads draws the "monte" card. The user attempts to guess
 *      which thread will hold the "monte" card.
 */


#include <algorithm>
#include <vector>

#include <assert.h>
#include <libgen.h>
#include <pthread.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "Barrier.hpp"
#include "Card.hpp"
#include "Deck.hpp"

using namespace std;


// MARK: Type Definitions

/*
 * This is the shared state passed to all the threads.
 */
typedef struct {
    Barrier *          mBarrier; // Shared synchronization barrier.
    pthread_mutex_t *  mLock;    // Shared serialization lock.
    Deck *             mPile;    // Pile of cards for the game.
    Card *             mMonte;   // Card the player is guessing.
    pthread_t          mGuess;   // Thread the player thinks has the card.
    bool *             mMatch;   // Status indicating a win.
} ThreadState;


// MARK: Function Prototypes

static void DisplayCard(FILE *inStream, const Card &inCard);
static void *ThreadPlay(void *inArg);


// MARK: Global Variables

static const char sCardSuits[kCardSuits] = {
	'C', 'D', 'H', 'S'
};

static const char * const sCardRanks[kCardRanks] = {
	"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"
};


/**
 *  @brief
 *    This routine displays to the standard output the specified card.
 *
 *  @param[in]  inStream  A pointer to the stream to display the card to.
 *  @param[in]  inCard    A reference to the immutable card to display.
 *
 */
static void
DisplayCard(FILE *inStream, const Card &inCard)
{
	char suit = sCardSuits[inCard.GetSuit()];
	const char *rank = sCardRanks[inCard.GetRank()];

	fprintf(inStream, "%2s%c", rank, suit);
}

/**
 *  @brief
 *    This routine is the multi-threaded entry point for the game.
 *
 *  @param[in,out]  inArg  A pointer to the thread state, with the
 *                         @a mMatch field updated.
 *
 *  @returns
 *    NULL
 *
 */
static void *
ThreadPlay(void *inArg)
{
	int status;

	(void)status;

	assert(inArg != NULL);

	pthread_t self = pthread_self();
	ThreadState &tsp = *(static_cast<ThreadState *>(inArg));

	// Take the serialization lock before drawing a card.

	status = pthread_mutex_lock(tsp.mLock);
	assert(status == 0);

	Card *myCard = tsp.mPile->Draw();

	status = pthread_mutex_unlock(tsp.mLock);
	assert(status == 0);

	// With our card drawn, wait at the serialization barrier until
	// all other threads have also drawn a card.

	status = tsp.mBarrier->Wait();
	assert(status == 0);

	// Take the serialization lock and reveal our card to the player
	// and record whether or not there's a winning match.

	status = pthread_mutex_lock(tsp.mLock);
	assert(status == 0);

	fprintf(stdout, "[%c] ", tsp.mGuess == self ? '*' : ' ');

	DisplayCard(stdout, *myCard);

	fprintf(stdout, " %c= ", *myCard == *(tsp.mMonte) ? '=' : '!');

	DisplayCard(stdout, *(tsp.mMonte));

	fprintf(stdout, "\n");

	// Logically OR in match status so that a non-matching thread
	// doesn't overwrite an earlier matching thread.

	*(tsp.mMatch) |= ((*myCard == *(tsp.mMonte)) && (tsp.mGuess == self));

	status = pthread_mutex_unlock(tsp.mLock);
	assert(status == 0);

	/* Delete the card since we are done with it. */

	delete myCard;

	return (NULL);
}

int
main(int argc, char * const argv[])
{
	int status;
	pthread_t tid;
	vector<pthread_t> threads;
	pthread_attr_t pattr;
	Barrier barrier;
	pthread_mutex_t lock;
	ThreadState arg;
	Deck deck, pile;

	(void)status;

	/* Parse arguments */

	if (argc != 3) {
		fprintf(stderr, "Usage: `%s' <cards> <guess>\n", basename(argv[0]));
		return (EXIT_FAILURE);
	}

	// Determine the number of cards (maps to threads zero-based).

	const int kCards = atoi(argv[1]);

	if (kCards < 3) {
		fprintf(stderr, "Cards must be greater than or equal to 3.\n");
		return (EXIT_FAILURE);
	}

	// Determine the guess (one-based).

	int guess = atoi(argv[2]);

	if (guess < 0 || guess > kCards) {
		fprintf(stderr, "You must make a guess between 1 and %d\n", kCards);
		return (EXIT_FAILURE);
	}

	fprintf(stdout, "Cards: %d\n", kCards);
	fprintf(stdout, "Guess: %d\n", guess);

	/* Initialize the "deck" by filling it with "cards".
	 *
	 * NOTE: While we do generate cards with new, since this is
	 * strictly a toy program, we are intentionally sloppy and do not
	 * call delete on the cards at the conclusion but rather let the
	 * runtime environment clean things up after exit.
	 */

	for (int suit = kCardSuitFirst; suit <= kCardSuitLast; suit++) {
		for (int rank = kCardRankFirst; rank <= kCardRankLast; rank++) {
			Card *theCard = new Card(static_cast<CardSuit>(suit),
									 static_cast<CardRank>(rank));
			assert(theCard != NULL);
			deck.Add(*theCard);
		}
	}

	/* Shuffle the deck. */

	deck.Shuffle();

	/*
	 * Initialize the thread infrastructure which handles the number of
	 * "cards" being played.
	 */

	status = barrier.Init(kCards);
	assert(status == 0);

	status = pthread_mutex_init(&lock, NULL);
	assert(status == 0);

	status = pthread_attr_init(&pattr);
	assert(status == 0);

	status = pthread_attr_setdetachstate(&pattr, PTHREAD_CREATE_JOINABLE);
	assert(status == 0);

	/* "Draw" the monte card and add it to the pile. */

	fprintf(stdout, "Drawing \"monte\" card: ");

	Card *monte = deck.Draw();
	assert(monte != NULL);

	pile.Add(*monte);

	DisplayCard(stdout, *monte); fprintf(stdout, "\n");

	/* "Draw" the remaining cards and add them to the pile. */

	fprintf(stdout, "Drawing remaining cards: ");

	for (int t = 0; t < kCards - 1; t++) {
		Card *theCard = deck.Draw();
		assert(theCard != NULL);

		pile.Add(*theCard);

		DisplayCard(stdout, *theCard); fprintf(stdout, " ");
	}

	fprintf(stdout, "\n");

	assert(pile.GetCount() == static_cast<size_t>(kCards));

	/* Shuffle the pile */

	pile.Shuffle();

	/* Start playing multi-thread monte by spawing the threads. */

	bool match = false;

	arg.mBarrier = &barrier;
	arg.mLock = &lock;
	arg.mPile = &pile;
	arg.mMonte = monte;
	arg.mMatch = &match;

	for (int t = 0; t < kCards; t++) {
		status = pthread_create(&tid, &pattr, ThreadPlay, &arg);
		assert(status == 0);

		threads.push_back(tid);

		if (t == guess - 1) {
			status = pthread_mutex_lock(&lock);
			assert(status == 0);

			arg.mGuess = tid;

			status = pthread_mutex_unlock(&lock);
			assert(status == 0);
		}
	}

	/*
	 * Join all threads to ensure all of them have a chance to finish
	 * the game. Otherwise, the main thread would exit and terminate
	 * them.
	 */

	vector<pthread_t>::iterator thread, begin, end;
	begin = threads.begin();
	end = threads.end();

	for (thread = begin; thread < end; thread++) {
		status = pthread_join((pthread_t)(*thread), NULL);
		assert(status == 0);
	}

	/* Clean-up */

	status = pthread_attr_destroy(&pattr);
	assert(status == 0);

	status = barrier.Shutdown();
	assert(status == 0);

	status = pthread_mutex_destroy(&lock);
	assert(status == 0);

	/* Delete any remaining cards in the deck. */

	size_t remaining = deck.GetCount();

	for (size_t n = 0; n < remaining; n++) {
		Card *theCard = deck.Draw();
		delete theCard;
	}

	/* Return status, success if the user guessed correctly;
	 * otherwise, failure.
	 */

	fprintf(stdout, "You %s!\n", match ? "WON" : "LOST");

	return (match ? EXIT_SUCCESS : EXIT_FAILURE);
}
