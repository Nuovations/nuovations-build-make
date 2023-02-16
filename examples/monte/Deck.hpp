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
 *      This file defines an object effecting a deck of playing cards.
 *
 */

#ifndef DECK_HPP
#define DECK_HPP


#include <vector>

#include <stddef.h>
#include <stdint.h>

#include "Card.hpp"


class Deck
{

public:
	// Con/destructor(s)
	         Deck(void);
	virtual ~Deck(void);

	size_t   GetCount(void) const;
	void     Shuffle(void);
	void     Add(Card &inCard);
	Card *   Draw(void);

private:
	std::vector<Card *>  mCards;

};

#endif // DECK_HPP

