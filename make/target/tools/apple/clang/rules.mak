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
#      This file defines rules and targets common to all Apple
#      clang/LLVM versions.
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

ToolSedArgs=$(ClangSedArgs)
ToolGrepArgs=$(ClangGrepArgs)
ToolVersionArgs="--version"

# Apple's clang/LLVM 'ar' does not exist and, by extension does not
# support a version option. Use sed to delete all lines but the last
# one, and replace the last line with "<none>" to just emit and match
# "<none>".

do-check-ar: ToolPath=$(AR)
do-check-ar: ToolSedArgs='1,1!d;s,^.+$$,<none>,gp'
do-check-ar: ToolGrepArgs='<none>'
do-check-ar: ToolDescription="clang/LLVM archiver"

do-check-as: ToolPath=$(AS)
do-check-as: ToolDescription="clang/LLVM assembler"

do-check-cpp: ToolPath=$(CPP)
do-check-cpp: ToolDescription="clang/LLVM preprocessor"

do-check-gcc: ToolPath=$(CC)
do-check-gcc: ToolDescription="clang/LLVM C compiler"

do-check-g++: ToolPath=$(CXX)
do-check-g++: ToolDescription="clang/LLVM C++ compiler"

do-check-ld: ToolPath=$(LD)
do-check-ld: ToolDescription="clang/LLVM linker"

do-check-nm: ToolPath=$(NM)
do-check-nm: ToolDescription="clang/LLVM symbol lister"

# Apple's clang/LLVM 'objcopy' does not exist and, by extension does not
# support a version option. Use sed to delete all lines but the last
# one, and replace the last line with "<none>" to just emit and match
# "<none>".

do-check-objcopy: ToolPath="echo <none>"
do-check-objcopy: ToolSedArgs='1,1!d;s,^.+$$,<none>,gp'
do-check-objcopy: ToolGrepArgs='<none>'
do-check-objcopy: ToolDescription="clang/LLVM file translator"

# Apple's clang/LLVM 'ranlib' does not exist and, by extension does not
# support a version option. Use sed to delete all lines but the last
# one, and replace the last line with "<none>" to just emit and match
# "<none>".

do-check-ranlib: ToolPath=$(RANLIB)
do-check-ranlib: ToolSedArgs='1,1!d;s,^.+$$,<none>,gp'
do-check-ranlib: ToolGrepArgs='<none>'
do-check-ranlib: ToolDescription="clang/LLVM library indexer"

# Apple's clang/LLVM 'strip' does not exist and, by extension does not
# support a version option. Use sed to delete all lines but the last
# one, and replace the last line with "<none>" to just emit and match
# "<none>".

do-check-strip: ToolPath=$(STRIP)
do-check-strip: ToolSedArgs='1,1!d;s,^.+$$,<none>,gp'
do-check-strip: ToolGrepArgs='<none>'
do-check-strip: ToolDescription="clang/LLVM symbol stripper"

do-check-ar do-check-as do-check-cpp do-check-gcc do-check-g++ do-check-ld do-check-nm do-check-objcopy do-check-ranlib do-check-strip:
	$(check-tool-version)
