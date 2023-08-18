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
#      This file is the make header for all PERL-related tools.
#

ifndef PerlVersion
export PerlVersion := $(shell perl -V:version | $(SED) $(SEDFLAGS) -n -e "s/^version='\(.\{1,\}\)';$$/\1/gp")
endif

ifndef PerlSiteDir
export PerlSiteDir := $(HostDataDir)/perl/$(PerlVersion)
endif

ifndef PERL
export PERL        := perl -I$(PerlSiteDir)
endif
