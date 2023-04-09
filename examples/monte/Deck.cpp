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
 *      This file implements an object effecting a deck of playing
 *      cards.
 *
 */


#include "Deck.hpp"

#include <algorithm>
#include <random>
#include <vector>

#include <stddef.h>
#include <stdint.h>
#include <time.h>
#include <unistd.h>

#include "Card.hpp"


using namespace std;


/**
 *  @brief
 *    This routine is a class default constructor. At present, it does
 *    nothing.
 *
 */
Deck::Deck(void)
{
	return;
}

/**
 *  @brief
 *    This routine is the class destructor. At present, it does nothing.
 *
 */
Deck::~Deck(void)
{
	return;
}

/**
 *  @brief
 *    This routine returns the number of cards in the deck.
 *
 *  @returns
 *    The number of cards in the deck.
 *
 */
size_t
Deck::GetCount(void) const
{
	return (mCards.size());
}

/**
 *  @brief
 *    This routine randomizes the order of cards in the deck.
 *
 */
void
Deck::Shuffle(void)
{
	shuffle(mCards.begin(), mCards.end(), default_random_engine());
}

/**
 *  @brief
 *    This routine adds a card to the deck.
 *
 *  @warning
 *    This does NOT check for duplicates in the deck!
 *
 *  @param[in]  inCard  A reference to the mutable card to be added.
 *
 */
void
Deck::Add(Card &inCard)
{
	mCards.push_back(&inCard);
}

/**
 *  @brief
 *    This routine "draws" a card from the deck.
 *
 *  @returns:
 *    A pointer to the "next" card in the deck if there are cards in
 *    the deck; otherwise, NULL;
 *
 */
Card *
Deck::Draw(void)
{
	Card *theCard;

	if (mCards.size() > 0) {
		theCard = mCards.back(); mCards.pop_back();

	} else {
		theCard = NULL;

	}

	return (theCard);
}
