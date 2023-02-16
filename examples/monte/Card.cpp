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
 *      This file implements an object for a playing card.
 *
 */


#include "Card.hpp"


/**
 *  @brief
 *    This routine is a class constructor. It simply sets member
 *    variables.
 *
 *  @param[in]  inSuit  The suit to initialize the card with.
 *  @param[in]  inRank  The rank to initialize the card with.
 *
 */
Card::Card(CardSuit inSuit, CardRank inRank) :
	mSuit(inSuit),
	mRank(inRank)
{
	return;
}

/**
 *  @brief
 *    This routine is the class copy constructor.
 *
 *  @param[in]   inCard  The card object to copy.
 *
 */
Card::Card(const Card &inCard)
{
	*this = inCard;
}

/**
 *  @brief
 *    This routine is the class destructor. At present, it does nothing.
 *
 */
Card::~Card(void)
{
	return;
}

/**
 *  @brief
 *    This routine returns the suit of the card.
 *
 *  @returns
 *    The suit of the card.
 *
 */
CardSuit
Card::GetSuit(void) const
{
	return (mSuit);
}

/**
 *  @brief
 *    This routine returns the rank of the card.
 *
 *  @returns
 *    The rank of the card.
 *
 */
CardRank
Card::GetRank(void) const
{
	return (mRank);
}

/**
 *  @brief
 *    This routine is an equality operator for the card, comparing it
 *    to another card.
 *
 *  @param[in]  inCompare  A reference to the immutable card being compared
 *                         to this card.
 *
 *  @returns
 *    True if this card is equal to the one being compared; otherwise,
 *    false.
 *
 */
bool
Card::operator ==(const Card &inCompare) const
{
	return ((inCompare.mSuit == mSuit) && (inCompare.mRank == mRank));
}
