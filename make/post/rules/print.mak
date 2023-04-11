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
#      This file is the make header for make variable debugging rules.
#

#
# Debugging Targets
#

.PHONY: print-%
print-%:
	$(Quiet)echo '$*=$($*)'
	$(Quiet)echo '....origin = $(origin $*)'
	$(Quiet)echo '....flavor = $(flavor $*)'
	$(Quiet)echo '.....value = $(value  $*)'
	$(Quiet)echo ''

# Specific variables to exclude from the output of "make printvars". These
# variables may include $(error ...) in their expansion, causing printvars to
# terminate early, or cause printvars to hang indefinitely.
#
printvars-filter := \
	ErrorIfUndefined

# Classes of variables, as described by $(origin ...), to exclude from the
# output of "make printvars".
#
printvars-origin-filter := \
	environment% \
	default \
	automatic

.PHONY: printvars
printvars:
	$(Quiet)$(foreach V,$(sort $(.VARIABLES)), \
		$(if $(filter-out $(printvars-origin-filter),$(origin $V)), \
			$(info $V=$(if $(filter-out $(printvars-filter),$V),$($V)))\
			$(info ....origin = $(origin $V)) \
			$(info ....flavor = $(flavor $V)) \
			$(info .....value = $(value  $V)) \
			$(info ) \
	))
