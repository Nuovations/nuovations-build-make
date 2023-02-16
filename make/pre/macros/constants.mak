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
#      This file defines make file constants common to all other make
#      headers and files.
#

#
# Character constants for those make does not otherwise handle well or
# naturally.
#

# Null or empty variable

Null                            := 

# Comma character

Comma                           := ,

# Dot character

Dot                             := .

# Space character. Make normally treats space (' ') as a delimiter,
# so we play this trick to generate a variable with a space.

Space                           := $(Null) $(Null)

# Path separator

Slash                           := /
