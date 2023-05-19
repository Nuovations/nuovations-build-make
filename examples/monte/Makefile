#
#    Copyright (c) 2008-2023 Nuovation System Design, LLC. All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

##
#    @file
#      This file is a make file for a simple, toy program this is
#      primarily intended for basic build and target system sanity
#      checking, demonstrating the basic structure and capabilities of a
#      build system make file and for demonstrating multi-threaded
#      debugging.
#

include pre.mak

LinkAgainstCPlusPlus    := Yes

PROGRAMS                 = \
    monte                  \
    $(Null)

monte_SOURCES            = \
    monte.cpp              \
    Barrier-$(TargetOS)    \
    Card.cpp               \
    Deck.cpp               \
    $(Null)

monte_PRIVATE_HEADERS    = \
    Barrier.hpp            \
    Card.hpp               \
    Deck.hpp               \
    $(Null)

monte_LDLIBS             = \
    pthread                \
    $(Null)

# Arugments to be passed to 'monte' for the 'execute' target.

monte_ARGUMENTS          = 3 2

include post.mak
