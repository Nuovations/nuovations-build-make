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
#      This file defines the host operating system and host tuple for the
#      build.
#
#

# We have to bootstrap ourselves into the notion of a correct host
# operating system. We do this by using uname.
#
# Note that conditionalizing and exporting this and HostTuple speed up
# recursive iteration by 24%.

ifndef HostOS
export HostOS           := $(shell uname -s | tr '[[:upper:]]' '[[:lower:]]')
endif # HostOS

# We have to bootstrap ourselves into the notion of a correct host
# tuple. We do this by using a known, project-local version of
# automake's config.guess.
#
# Note that conditionalizing and exporting this and HostOS speed up
# recursive iteration by 24%.

ifndef HostTuple
export HostTuple        := $(shell $(BuildRoot)/third_party/nuovations-build-make/repo/third_party/automake/repo/lib/config.guess)
endif # HostTuple

# Ensure that the value of HostOS is consistent with HostTuple.

ifeq ($(findstring $(HostOS),$(HostTuple)),)
$(error cannot find HostOS \"$(HostOS)\" in HostTuple \"$(HostTuple)\")
endif
