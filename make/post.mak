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
#      This file is the generic "tail" or post make header included in
#      any makefile used in the build tree.
#

include post/rules.mak

#
# This must always be at the end of this file and, similarly, the end
# of any file that, in turn, includes this one.
#
# We need to perform this multi-tiered dependency inclusion since make
# will complain in the presence of a perfectly clean build
# environment. In such case, there are effectively no dependencies to
# include until they've been generated the first time.
#
# Finally, we do not want to let dependencies get in the way of build
# cleaning make goals.
#

ifdef Dependencies
VerifiedDependencies := $(foreach depend,$(Dependencies),$(wildcard $(depend)))
ifdef VerifiedDependencies
ifeq ($(filter clean distclean,$(MAKECMDGOALS)),)
include $(VerifiedDependencies)
endif
endif # VerifiedDependencies
endif # Dependencies
