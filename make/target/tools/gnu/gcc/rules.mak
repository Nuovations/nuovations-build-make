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
#      This file defines rules and targets common to all GNU Compiler
#      Collection (GCC) versions.
#

.PHONY: maybe-check-binutils
maybe-check-binutils: maybe-check-archivers \
	maybe-check-objcopiers \
	maybe-check-linkers \
	maybe-check-strippers

.PHONY: maybe-check-assemblers
maybe-check-assemblers: do-check-as

.PHONY: maybe-check-preprocessors
maybe-check-preprocessors: do-check-cpp

.PHONY: maybe-check-archivers
maybe-check-archivers: do-check-ar do-check-ranlib

.PHONY: maybe-check-compilers
maybe-check-compilers: do-check-gcc \
	do-check-g++ \

.PHONY: maybe-check-linkers
maybe-check-linkers: do-check-ld

.PHONY: maybe-check-objcopiers
maybe-check-objcopiers: do-check-objcopy

.PHONY: maybe-check-strippers
maybe-check-strippers: do-check-strip

.PHONY: do-check-ar \
	do-check-as \
	do-check-cpp \
	do-check-gcc \
	do-check-g++ \
	do-check-ld \
	do-check-objcopy \
	do-check-ranlib \
	do-check-strip

ToolSedArgs=$(GccSedArgs)
ToolGrepArgs=$(GccGrepArgs)
ToolVersionArgs="--version"

do-check-ar: ToolPath=$(AR)
do-check-ar: ToolSedArgs=$(BinutilsSedArgs)
do-check-ar: ToolGrepArgs=$(BinutilsGrepArgs)
do-check-ar: ToolDescription="GNU archiver"

do-check-as: ToolPath=$(AS)
do-check-as: ToolDescription="GNU assembler"

do-check-cpp: ToolPath=$(CPP)
do-check-cpp: ToolDescription="GNU preprocessor"

do-check-gcc: ToolPath=$(CC)
do-check-gcc: ToolDescription="GNU C compiler"

do-check-g++: ToolPath=$(CXX)
do-check-g++: ToolDescription="GNU C++ compiler"

do-check-ld: ToolPath=$(LD)
ifeq ($(UseLdAsLinker),1)
do-check-ld: ToolSedArgs=$(BinutilsSedArgs)
do-check-ld: ToolGrepArgs=$(BinutilsGrepArgs)
endif
do-check-ld: ToolDescription="GNU linker"

do-check-nm: ToolPath=$(NM)
do-check-nm: ToolSedArgs=$(BinutilsSedArgs)
do-check-nm: ToolGrepArgs=$(BinutilsGrepArgs)
do-check-nm: ToolDescription="GNU library indexer"

do-check-objcopy: ToolPath=$(OBJCOPY)
do-check-objcopy: ToolSedArgs=$(BinutilsSedArgs)
do-check-objcopy: ToolGrepArgs=$(BinutilsGrepArgs)
do-check-objcopy: ToolDescription="GNU file translator"

do-check-ranlib: ToolPath=$(RANLIB)
do-check-ranlib: ToolSedArgs=$(BinutilsSedArgs)
do-check-ranlib: ToolGrepArgs=$(BinutilsGrepArgs)
do-check-ranlib: ToolDescription="GNU library indexer"

do-check-strip: ToolPath=$(STRIP)
do-check-strip: ToolSedArgs=$(BinutilsSedArgs)
do-check-strip: ToolGrepArgs=$(BinutilsGrepArgs)
do-check-strip: ToolDescription="GNU symbol stripper"

do-check-ar do-check-as do-check-cpp do-check-gcc do-check-g++ do-check-ld do-check-nm do-check-objcopy do-check-ranlib do-check-strip:
	$(check-tool-version)
