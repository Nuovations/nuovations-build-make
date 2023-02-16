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
#      This file defines make file string manipulation macros common to all
#      other make headers and files.
#

# Make does not handle spaces in file or target names well and barely
# at all at that (see http://www.cmcrossroads.com/content/view/7859/268/).
# So, we have to play either some "parlor tricks" or ensure there are
# no such spaces in any make variable rvalue that gets manipulated by
# make functions or ends up as a target.
#
# The following macros are provides to perform the appropriate
# translations when necessary.

EscapedSpace	:= \\\$(Space)
EncodedSpace	:= _

# EncodeSpaces <string>
#
# Transform all instances of "escaped spaces" in the specified string
# to "encoded spaces".

EncodeSpaces	= $(subst $(EscapedSpace),$(EncodedSpace),$(1))

# EscapeSpaces <string>
#
# Transform all instances of "encoded spaces" in the specified string
# to "escaped spaces".

EscapeSpaces	= $(subst $(EncodedSpace),$(EscapedSpace),$(1))

# UnencodeSpaces <string>
#
# Transform all instances of "encoded spaces" in the specified string
# to normal spaces.

UnencodeSpaces	= $(subst $(EncodedSpace),$(Space),$(1))

# UnescapeSpaces <string>
#
# Transform all instances of "escaped spaces" in the specified string
# to normal spaces.

UnescapeSpaces	= $(subst $(EscapedSpace),$(Space),$(1))

#
# Macros for manipulating strings
#

# ToLower <string>
#
# Convert all characters in a string from upper- or mixed-cased to
# lower-case.

ToLower		= $(shell echo $(1) | tr '[[:upper:]]' '[[:lower:]]')

# ToUpper <string>
#
# Convert all characters in a string from lower- or mixed-cased to
# upper-case.

ToUpper		= $(shell echo $(1) | tr '[[:lower:]]' '[[:upper:]]')

# ToSentence <string>
#
#
# Convert the first letter of the first word in a string to
# upper-case, as in a sentence.

ToSentence	= $(shell echo $(1) | perl -pe 's/\w.+/\u\L$$&/g')

# ToTitle <string>
#
# Convert the first letter of all words in a string to upper-case, as
# in a title.

ToTitle		= $(shell echo $(1) | perl -pe 's/(\w\S*)/\u\L$$1/g')

# Mid <string> <position> <number>
#
# Returns a specific number of characters from a string, starting at
# the specified position (zero-based), based on the number of
# characters specified.

Mid		= $(shell echo $(1) | awk '{ print(substr($$1,$(2)+1,$(3))) }')

# Left <string> <number>
#
# Returns the first (leftmost) character or characters in a string,
# based on the number of characters specified.

Left		= $(call Mid,$(1),0,$(2))

# Right <string> <number>
#
# Returns the last (rightmost) character or characters in a string,
# based on the number of characters specified.

Right		= $(call Mid,$(1),length($$1)-$(2),$(2))

# Length <string>
#
# Returns the number of characters in a string.

Length		= $(shell echo $(1) | awk '{ print(length($$1)) }')

# IsYes <string>
#
# If the specified string is 1, yes, YES, y or Y, returns 'Y';
# otherwise, ''.

IsYes		= $(subst N,,$(subst 0,N,$(call Left,$(call ToUpper,$(1)),1)))

# IsNo <string>
#
# If the specified string is 0, no, NO, n or N, returns 'N';
# otherwise, ''.

IsNo		= $(subst Y,,$(subst 1,Y,$(call Left,$(call ToUpper,$(1)),1)))

# Unique <string>
#
# Returns the string deduplicated of repeated substrings.

Unique          = $(if $(1),$(firstword $(1)) $(call Unique,$(filter-out $(firstword $1),$(1))))
