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
#      This file defines make macros for controlling build verbosity.
#

#
# Build verbosity
#
# Commands prefixed with $(Quiet) are never displayed. We macroize '@'
# in the event, we want some conditional behavior for $(Quiet) in the
# future.
#
# If make is not operating in silent mode and BuildVerbose is
# asserted, then all commands prefixed with $(Verbose) will be
# displayed; otherwise, commands are not displayed.
#

Quiet               = @

ifneq ($(findstring s,$(MAKEFLAGS)),)
Echo                = $(Quiet)true
Verbose             = $(Quiet)
else
Echo                = $(Quiet)/bin/echo
Verbose             = $(if $(call IsYes,$(BuildVerbose)),,@)
endif
