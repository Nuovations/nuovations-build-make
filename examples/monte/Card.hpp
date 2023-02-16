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
 *      This file defines an object for a playing card.
 *
 */

#ifndef CARD_HPP
#define CARD_HPP

typedef enum {
	kCardSuitFirst = 0,

	kClub          = kCardSuitFirst,
	kDiamond,
	kHeart,
	kSpade,

	kCardSuitLast  = kSpade,
	kCardSuits
} CardSuit;

typedef enum {
	kCardRankFirst = 0,

	kDuece         = kCardRankFirst,
	kThree,
	kFour,
	kFive,
	kSix,
	kSeven,
	kEight,
	kNine,
	kTen,
	kJack,
	kQueen,
	kKing,
	kAce,

	kCardRankLast  = kAce,
	kCardRanks
} CardRank;

class Card
{

public:
	// Con/destructor(s)
	         Card(CardSuit inSuit, CardRank inRank);
	         Card(const Card &inCard);
	virtual ~Card(void);

	CardSuit GetSuit(void) const;
	CardRank GetRank(void) const;

	bool operator ==(const Card &inRhs) const;

private:
	CardSuit  mSuit;
	CardRank  mRank;

};


#endif // CARD_HPP
