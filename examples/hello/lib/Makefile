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
#  @file
#    This file is a make file for a set of simple, toy libraries
#    that are primarily intended for basic build and target system
#    sanity checking as well as for demonstrating the basic structure
#    and capabilities of a build system make file.
#

include pre.mak

LinkAgainstCPlusPlus   := Yes

# DEFINES, INCLUDES, and LDLIBS for all LIRBARIES and ARCHIVES.

DEFINES                 = \
    LIBS=1                \
    $(Null)

INCLUDES                = \
    ../include            \
    $(Null)               \

LDLIBS                  = \
    m                     \
    $(Null)

WARNINGS                = $(call ToolAssertWarningFlag,$(WarnPointerMath))

# Shared Libraries

LIBRARIES               = \
    hello                 \
    goodbye               \
    salutations           \
    $(Null)

# SOURCES, DEFINES, INCLUDES, and LDLIBs for the 'hello' shared library.

hello_SOURCES           = \
    hello.c               \
    $(Null)

hello_DEFINES           = \
    HELLO                 \
    $(Null)

hello_INCLUDES          = \
    ../include/hello      \
    $(Null)

hello_LDLIBS            = \
    pthread               \
    $(Null)

# SOURCES, DEFINES, INCLUDES, and LDLIBs for the 'goodbye' shared library.

goodbye_SOURCES         = \
    goodbye.cpp           \
    $(Null)

goodbye_DEFINES         = \
    GOODBYE               \
    $(Null)

goodbye_INCLUDES        = \
    ../include/goodbye    \
    $(Null)

goodbye_LDLIBS          = \
     $(Null)

# SOURCES, DEFINES, INCLUDES, and WARNINGS for the 'salulations'
# shared library.

salutations_SOURCES     = \
     hi.c bye.c           \
     $(Null)

salutations_DEFINES     = \
     SALUTATIONS          \
     $(Null)

salutations_INCLUDES    = \
     ../include/salutations

salutations_WARNINGS    = $(call ToolAssertWarningFlag,$(WarnExtra))
salutations_WARNINGS   += $(call ToolAssertWarningFlag,$(WarnUnusedValues))

# Archive Libraries

ARCHIVES                = \
    alphabet              \
    $(Null)

# SOURCES, DEFINES, INCLUDES, and WARNINGS for the 'alphabet' archive
# library.

alphabet_SOURCES        = \
    a.c                   \
    b.c                   \
    c.c                   \
    d.c                   \
    e.c                   \
    f.c                   \
    g.c                   \
    h.c                   \
    $(Null)

alphabet_DEFINES        = \
    ALPHABET              \
    $(Null)

alphabet_INCLUDES       = \
    ../include/alphabet   \
    $(Null)

alphabet_WARNINGS       = $(call ToolAssertWarningFlag,$(WarnExtra))
alphabet_WARNINGS      += $(call ToolAssertWarningFlag,$(WarnUnusedValues))

include post.mak
