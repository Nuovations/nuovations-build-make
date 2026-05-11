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
#      This file defines make file environment variables common to
#      all host build environments.
#

BinarySearchPath       = PATH
LoaderSearchPath       = LD_LIBRARY_PATH

##
#  @brief
#    Generate a colon-separated loader search path string from a list
#    of library file paths, with the directories of these files
#    prepended to the existing value of the dynamic loader search
#    path environment variable named by $(LoaderSearchPath).
#
#  Caller-specified order is preserved: directories appear in the
#  input order before the existing path elements. Duplicates are NOT
#  removed, since lexical sorting would destroy the precedence
#  semantics of loader search paths (where earlier entries override
#  later ones). Callers who genuinely want duplicate removal can
#  uniqify their input list before calling.
#
#  Empty inputs are handled gracefully: no leading colons, no
#  spurious empty entries.
#
#  @param[in]  1: Whitespace-separated list of library file paths.
#                 (The directories of these files are prepended; the
#                 file basenames are ignored.)
#
LoaderSearchPathString = $(subst $(Space),:,$(strip $(dir $(1)) $($(LoaderSearchPath))))
