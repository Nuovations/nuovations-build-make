#
#    Copyright (c) 2023 Nuovation System Design, LLC. All Rights Reserved.
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
#      This file defines make file constants for make build jobs and
#      flags, common to all other make headers and files.
#

##
#  The default recommended number of make build jobs, based on the
#  number of processors currently available or online.
#
#  More build jobs than this is typically ineffective.
#
ifndef BuildJobsDefault
export BuildJobsDefault := $(shell getconf _NPROCESSORS_ONLN)
endif

##
#  The number of build jobs specified at the time of make invocation
#  on the command line, parsed from MAKEFLAGS.
#
#  If no build jobs were specified, this may be empty.
#
ifndef BuildJobs
export BuildJobs         = $(shell echo "$(MAKEFLAGS)" | $(SED) $(SEDFLAGS) -n -r -e "s/^.+-(j|-jobs)[[:space:]]*=*[[:space:]]*([[:digit:]]+).*$$/\2/gp")
endif

##
#  The make jobs flag argument to add and pass to make (for example,
#  '-j4'), based on 'BuildJobs'.
#
#  This is useful is MAKEFLAGS has been otherwise unset or filtered,
#  for example, when doing a sub-make of third-party software with its
#  own make-based build system:
#
#    unset MAKEFLAGS && $(MAKE) $(MAKEJOBSFLAG) -C $(PackageBuildDirectory)
#
ifndef MAKEJOBSFLAG
export MAKEJOBSFLAG      = $(if $(BuildJobs),-j$(BuildJobs),)
endif
