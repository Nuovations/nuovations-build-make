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
#      This file defines make rules and targets for performing coding 
#      style formatting and checking.
#
#      The recursive target 'pretty', invoked against '$(PrettyMakefiles)', 
#      is intended to reformat a collection of source files, defined by 
#      '$(PrettyPaths)' using the program '$(PRETTY)' with the arguments 
#      '$(PRETTY_ARGS)'.
#
#      The recursive target 'pretty-check' (and its alias 'lint'), invoked  
#      against '$(PrettyMakefiles)', is intended to only check but NOT  
#      reformat a collection of source files, defined by '$(PrettyPaths)'  
#      using the program '$(PRETTY_CHECK)' with the arguments 
#      '$(PRETTY_CHECK_ARGS)'.
#
#      This represents the minimum integration with GNU autotools
#      (automake inparticular) such that 'make pretty' and 'make
#      pretty-check' may be invoked at the top of the tree and all 
#      the prerequisites occur such that it executes successfully 
#      with no intervening make target invocations. '$(BUILT_SOURCES)' 
#      are the key automake-specific dependencies to ensure that happens.
#

# make-pretty <OUTPUT COMMAND> <COMMAND> <COMMAND ARGUMENTS> <PATHS>
#
# This function iterates over PATHS, invoking COMMAND with
# COMMAND ARGUEMENTS on each file. OUTPUT COMMAND is emitted to standard 
# output.

define make-pretty
$(Quiet)for file in $(4); do \
    $(1) \
    $(2) $(3) $${file} \
    || exit 1; \
done
endef

.PHONY: pretty pretty-recursive pretty-check pretty-check-recursive lint

pretty: pretty-recursive

# Map the top-level build action 'lint' to the more vernacular 'pretty-check'.

lint: pretty-check

pretty-check: pretty-check-recursive

pretty-recursive pretty-check-recursive: $(PrettyMakefiles)

# If PrettyMakefiles has been defined and there are makefiles that are
# not a subset of SubMakefiles, then we need a target comment to
# process them.

ifdef PrettyMakefiles
ifneq ($(filter-out $(SubMakefiles),$(PrettyMakefiles)),)
$(filter-out $(SubMakefiles),$(PrettyMakefiles)): force
	$(make-submakefile-target)
endif # ($(filter-out $(SubMakefiles),$(PrettyMakefiles)),)
endif # PrettyMakefiles

pretty: $(PrettyPaths)
ifneq ($(PRETTY),)
	$(call make-pretty,$(PrettyVerbose),$(PRETTY),$(PRETTY_ARGS),$(filter-out $(@)-recursive,$(^)))
endif

pretty-check: $(PrettyPaths)
ifneq ($(PRETTY_CHECK),)
	$(call make-pretty,$(PrettyCheckVerbose),$(PRETTY_CHECK),$(PRETTY_CHECK_ARGS),$(filter-out $(@)-recursive,$(^)))
endif
