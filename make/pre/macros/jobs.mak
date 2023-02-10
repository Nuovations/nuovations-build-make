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

#
#    Description:
#      This file defines make macros for specifing the number of make
#      recipes (jobs) to run simultaneously.
#

# BuildJobs
#
# The number of make recipes (jobs) to run simultaneously.
#
# This may be an integral number from 1 to n.
#
# It is recommended that this number NOT exceed the number of
# schedulable CPUs in the system.

ifndef BuildJobs
_BuildNumProcessors := $(shell getconf _NPROCESSORS_ONLN)

# UseRandomBuildJobs
#
# This is a Boolean that when asserted will assign a random number of
# build jobs to 'BuildJobs' up to the value returned by `getconf
# _NPROCESSORS_ONLN`.

_UseRandomBuildJobsDefault    := No
UseRandomBuildJobs            ?= $(_UseRandomBuildJobsDefault)

ifeq ($(call IsYes,$(UseRandomBuildJobs)),Y)
BuildJobs                     := $(shell bash -c 'echo $$(((RANDOM % $(_BuildNumProcessors)) + 1))')
else
BuildJobs                     := $(_BuildNumProcessors)
endif # UseRandomBuildJobs
endif # BuildJobs

# BuildJobsFlag
#
# The make invocation option used to specify the number of make
# recipes (jobs) to run simultaneously.

BuildJobsFlag                 := --jobs=$(BuildJobs)

# If the number of build jobs has been defined to be greater than one
# (1), then ensure that the top-level make process has a build jobs
# flag. Since MAKEFLAGS gets passed down to sub-makefiles, we do not
# want the build jobs flag defined in them and want to use the
# built-in make jobserver instead. Consequently, filter out the build
# jobs flag for sub-makefiles.

ifneq (1,$(BuildJobs))
ifeq (0,${MAKELEVEL})
MAKEFLAGS                     += $(BuildJobsFlag)
else
MAKEFLAGS                     := $(filter-out $(BuildJobsFlag),$(MAKEFLAGS))
endif
endif

ifeq ($(call IsYes,$(BuildVerbose)),Y)
$(info "MAKEFLAGS = $(MAKEFLAGS)")
endif
