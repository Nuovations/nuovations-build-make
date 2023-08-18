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
#      This file defines access paths, environment variables and basic
#      flags for tools common to all Apple clang/LLVM versions.
#

# Some common clang/LLVM-specific variables and macros

ClangAssertFlag                 = $(if $(2),$(1)$(2),)
ClangDeassertFlag               = $(if $(2),$(1)no-$(2),)

ClangWarningFlag                = -W
ToolAssertWarningFlag           = $(call ClangAssertFlag,$(ClangWarningFlag),$(1))
ToolDeassertWarningFlag         = $(call ClangDeassertFlag,$(ClangWarningFlag),$(1))

ClangLanguageFlag               = -f
ToolAssertLanguageFlag          = $(call ClangAssertFlag,$(ClangLanguageFlag),$(1))
ToolDeassertLanguageFlag        = $(call ClangDeassertFlag,$(ClangLanguageFlag),$(1))

ClangLanguageStandardFlag       = -std=
ToolAssertLanguageStandardFlag  = $(call ClangAssertFlag,$(ClangLanguageStandardFlag),$(1))

ClangMachineFlag                = -m
ToolAssertMachineFlag           = $(call ClangAssertFlag,$(ClangMachineFlag),$(1))
ToolDeassertMachineFlag         = $(call ClangDeassertFlag,$(ClangMachineFlag),$(1))

ToolAssertLanguageSanitizerFlag = $(call ToolAssertLanguageFlag,$(LangSanitize)=$(1))

ClangLinkerFlag                 = -Wl,

ClangAssertLinkerFlag           = $(if $(2),$(1)$(2))

ToolAssertLinkerFlag            = $(call ClangAssertLinkerFlag,$(ClangLinkerFlag),$(1))

ClangOutputFlag                 = -o
ClangNoAssembleFlag             = -S
ClangNoLinkFlag                 = -c
ClangInputFlag                  = 
ClangPICFlag                    = $(call ToolAssertLanguageFlag,PIC)
ClangCoverageFlag               = --coverage

# Debug variables

DebugFlag                       = -g

# Profile variables

ProfileFlag                     = -pg

# Optimizer variables

OptimizeNone                    = -O0
OptimizeLeast                   = -O1
OptimizeLess                    = -O1
OptimizeMore                    = -O2
OptimizeMost                    = -O3
OptimizeSize                    = -Os

# Language variables

LangForwardPropagation          = forward-propagate
LangExceptionHandling           = exceptions
LangRuntimeTypeInformation      = rtti
LangFunctionSections            = function-sections
LangDataSections                = data-sections
LangSanitize                    = sanitize
LangStackProtection             = stack-protector-all
LangOmitFramePointer            = omit-frame-pointer
LangOptimizeSiblingCalls        = optimize-sibling-calls

# Language sanitizers

LangSanitizeAddress             := address
LangSanitizeLeak                := leak
LangSanitizeThread              := thread
LangSanitizeUndefined           := undefined 

# Language standards

LangStandardC1990               := c90
LangStandardC1999               := c99
LangStandardC2011               := c11
LangStandardC2017               := c17
LangStandardCNext               := c2x

LangStandardCxx1998             := c++98
LangStandardCxx2003             := c++03
LangStandardCxx2011             := c++11
LangStandardCxx2014             := c++14
LangStandardCxx2017             := c++17
LangStandardCxxNext             := c++2a

# Warning variables

WarnEnable                      =
WarnDisable                     = -w
WarnAll                         = all
WarnWarningsAreErrors           = error
WarnCharIndices                 = char-subscripts
WarnExtra                       = extra
WarnFormatStrings               = format
WarnImplicitDeclarations        = implicit
WarnShadow                      = shadow
WarnReturnType                  = return-type
WarnMissingProtos               = missing-prototypes
WarnStrictProtos                = strict-prototypes
WarnNonVirtualDestructors       = non-virtual-dtor
WarnParentheses                 = parentheses
WarnPointerMath                 = pointer-arith
WarnReturnType                  = return-type
WarnSequencePoint               = sequence-point
WarnUninitialized               = uninitialized
WarnUnused                      = unused
WarnUnusedLabels                = unused-label
WarnUnusedParams                = unused-parameter
WarnUnusedValues                = unused-value
WarnUnusedVars                  = unused-variable
WarnUnusedFunctions             = unused-function
WarnWritableStrings             = write-strings
WarnTypeLimits                  = type-limits
WarnStackProtection             = stack-protector

# The archiver (librarian)

AR                              := $(ToolBinDir)/ar
ARName                          = $(call MakeToolName,$(AR))
ARInputFlag                     = 
AROutputFlag                    = 
ARCreateFlag                    = -c
ARReplaceFlag                   = -r
ARCreateStaticIndexFlag         = -s

ARFLAGS                         = $(ARCreateFlag) $(ARReplaceFlag) $(ARCreateStaticIndexFlag)

# The assembler

AS                              := $(ToolBinDir)/clang
ASName                          = $(call MakeToolName,$(AS))
ASInputFlag                     = $(ClangInputFlag)
ASOutputFlag                    = $(ClangOutputFlag)

ASFLAGS                         += $(ASOPTFLAGS) $(ASWARNINGS) $(ClangNoLinkFlag)

# The C preprocessor

CPP                             := $(CCACHE) $(ToolBinDir)/cpp
CPPName                         = $(call MakeToolName,$(CPP))
CPPDefineFlag                   = -D
CPPUndefineFlag                 = -U
CPPIncludeFlag                  = -I
CPPInputFlag                    = $(ClangInputFlag)
CPPOutputFlag                   = $(ClangOutputFlag)
CPPDependFlags                  = -MT "$@ $(call GenerateDependPaths,$*.d)" -MD -MP -MF "$(call GenerateDependPaths,$*.d)"

CPPFLAGS                        = $(CPPOPTFLAGS) \
                                  $(call ToolGenerateDefineArgument,$(DEFINES)) \
                                  $(call ToolGenerateUndefineArgument,$(UNDEFINES)) \
                                  $(call ToolGenerateIncludeArgument,$(INCLUDES)) \
                                  $(if $(filter-out %.d,$@),$(CPPDependFlags))

# The C compiler

CC                              := $(CCACHE) $(ToolBinDir)/clang
CCName                          = $(call MakeToolName,$(CC))
CCNoAssembleFlag                = $(ClangNoAssembleFlag)
CCNoLinkFlag                    = $(ClangNoLinkFlag)
CCInputFlag                     = $(ClangInputFlag)
CCOutputFlag                    = $(ClangOutputFlag)
CCPICFlag                       = $(ClangPICFlag)
CCCoverageFlag                  = $(ClangCoverageFlag)

CCFLAGS                         = $(CCOPTFLAGS) $(CCWARNINGS)

# The C++ compiler

CXX                             := $(CCACHE) $(ToolBinDir)/clang++
CXXName                         = $(call MakeToolName,$(CXX))
CXXNoAssembleFlag               = $(ClangNoAssembleFlag)
CXXNoLinkFlag                   = $(ClangNoLinkFlag)
CXXInputFlag                    = $(ClangInputFlag)
CXXOutputFlag                   = $(ClangOutputFlag)
CXXPICFlag                      = $(ClangPICFlag)
CXXCoverageFlag                 = $(ClangCoverageFlag)

CXXFLAGS                        = $(CXXOPTFLAGS) $(CXXWARNINGS)

# The Objective C compiler flag

OBJCCLanguage                   := -x objective-c

# The Objective C++ compiler flag

OBJCXXLanguage                  := -x objective-c++

# The dependency generator

DEPEND                          := $(ToolBinDir)/cpp
DEPENDName                      = $(call MakeToolName,$(DEPEND))
DEPENDInputFlag                 =
DEPENDOutputFlag                = -o

DEPENDFLAGS                     = -E -MT "$(call GenerateBuildPaths,$*.o) $@" -MM -MP -MF $@

# The linker

LinkAgainstCPlusPlus_          := N
LinkAgainstCPlusPlus_N          = $(call IsNo,$(LinkAgainstCPlusPlus))
LinkAgainstCPlusPlus_Y          = $(call IsYes,$(LinkAgainstCPlusPlus))

LD_LinkAgainstCPlusPlus_       := $(ToolBinDir)/clang
LD_LinkAgainstCPlusPlus_N      := $(LD_LinkAgainstCPlusPlus_)
LD_LinkAgainstCPlusPlus_Y       = $(ToolBinDir)/clang++

LD                              = $(LD_LinkAgainstCPlusPlus_$(LinkAgainstCPlusPlus_Y))

LDName                          = $(call MakeToolName,$(LD))
LDLibraryNameFlag               = -l
LDLibraryPathFlag               = -L
LDOutputFlag                    = $(ClangOutputFlag)

#
# The linker and, by extension, linking are quite a bit different on
# macOS than on most other UNIX-based platforms. Explicitly override
# how we link a shared library or program executable.
#

LDSharedFlag                    = -dynamiclib
LDExportDynamicSymbols          = $(call ToolAssertLinkerFlag,-rdynamic)
LDSharedNameFlag                = $(call ToolAssertLinkerFlag,-install_name$(Comma))
LDResolvePathFlag               = $(call ToolAssertLinkerFlag,-dylib_file$(Comma):)
LDGCovFlag                      = --coverage -lprofile_rt

# The symbol lister

NM                              := $(ToolBinDir)/nm
NMName                          = $(call MakeToolName,$(NM))

# The object copier

OBJCOPY                         := $(ToolBinDir)/objcopy
OBJCOPYName                     = $(call MakeToolName,$(OBJCOPY))

# The library indexer

RANLIB                          := $(ToolBinDir)/ranlib
RANLIBName                      = $(call MakeToolName,$(OBJCOPY))

# The symbol stripper

STRIP                           := $(ToolBinDir)/strip
STRIPName                       = $(call MakeToolName,$(STRIP))

ToolGenerateArgument             = $(if $(2),$(addprefix $(1),$(2)))

ToolGenerateIncludeArgument      = $(call ToolGenerateArgument,$(CPPIncludeFlag),$(1))
ToolGenerateDefineArgument       = $(call ToolGenerateArgument,$(CPPDefineFlag),$(1))
ToolGenerateUndefineArgument     = $(call ToolGenerateArgument,$(CPPUndefineFlag),$(1))

ToolGenerateLibraryPathArgument  = $(call ToolGenerateArgument,$(LDLibraryPathFlag),$(1))
ToolGenerateLibraryNameArgument  = $(call ToolGenerateArgument,$(LDLibraryNameFlag),$(1))

ToolLibraryPathArgumentIsPath    = $(if $(call IsRelativePath,$(1)),$(call GenerateResultPaths,,$(dir $(1))),$(dir $(1)))
ToolLibraryPathArgumentIsNotPath =

ToolLibraryPathArgumentHandler   = $(if $(call IsPath,$(1)),$(call ToolLibraryPathArgumentIsPath,$(1)),$(call ToolLibraryPathArgumentIsNotPath,$(1)))

# GenerateLibraryPathArgument <argument>
#
# This generates the library search path component of a link library
# as follows:
#
#   * Arguments that are relative paths (i.e. contain a directory
#     delimiter but no leading delimiter) generate an absolute search
#     path, relative to the current results directory.
#
#   * Arguments that are absolute paths (i.e. contain a directory
#     delimiter and a leading delimiter) are untouched and generate a
#     search path as is.
#
#   * Arguments that are not paths (i.e. contain no directory
#     delimiter) are assumed to be system libraries and generate no search
#     path.

GenerateLibraryPathArgument     = $(call ToolGenerateLibraryPathArgument,$(call ToolLibraryPathArgumentHandler,$(1)))

GenerateLibraryNameArgument     = $(call ToolGenerateLibraryNameArgument,$(notdir $(1)))
GenerateLibraryArgument         = $(call GenerateLibraryPathArgument,$(1)) $(call GenerateLibraryNameArgument,$(1))

GenerateLibraryArguments        = $(foreach library,$(1),$(call GenerateLibraryArgument,$(library)))

# GenerateResolvePathArgument <argument>
#
# This generates the library resolve search path of a dependent
# library. These are typically passed at the end of a link command for
# executable and shared library targets to resolve library
# dependencies not of the link target ITSELF but of the link target's
# shared libraries.
#
# Let's say that target foo depends on libbar.so and that libbar.so
# depends on liba.so and libb.so. Without specifying resolve paths,
# foo would need to link against lbar, la and lb. The first makes
# sense; however, the latter two would be surprising because, to the user
# of the 'bar' library, they are effectively hidden. Nonetheless, the
# linker still needs to know they exist and can be, eventually, resolved.
#
# So, there are two solutions to this problem. The first option, just
# specifies these "hidden" and "missing" libraries as link
# dependencies. However, as you travel "up" the library stack, you end
# up have an geometrically-increasing set of link libraries
# required. You depend on not only what you link against but
# everything they linked against and on down the dependency tree.
#
# The second option specifies these "hidden" and "missing" libraries
# as resolve dependencies without actually linking them. This keeps
# library requirements as you move "up" the library stack constant,
# that is you only depend on what you link against, not everything
# those libraries linked against.
#
# When cross-compiling, it is almost impossible to get rid of the need
# to be aware that these libraries are "missing"; however, by using
# resolve paths, the names can be resolved without having those
# "missing" libraries end up in the "NEEDED" section of the target.

GenerateResolvePathArgument     = $(call ToolGenerateArgument,$(LDResolvePathFlag),$(1))

GenerateResolveArgument         = $(call GenerateResolvePathArgument,$(1))

GenerateResolveArguments        = $(foreach library,$(1),$(call GenerateResolveArgument,$(library)))

#
# Macros for checking clang/LLVM tool versions
#

ClangSedVendor          = Apple

# The name of the clang/LLVM-based tool, which can be one or more of any
# character, other than space (' ').

ClangSedTool            = [^ ]+

# The version of the clang/LLVM-based tool, which must be precisely a
# two- or three-digit tuple where each tuple is one or more digits, separated
# by a period (.).

ClangSedVers            = ([[:digit:]]{1,}.*){2,3}

# The build of the clang/LLVM-based tool, which can be any non-empty set of characters.

ClangSedBuild           = .+

# The form of the version string for clang/LLVM-based tools is "{<tool
# vendor><space>}<tool name><space>version<space><version><not digit
# or period>(<distribution-specific build>)" where braced ('{...}')
# sequences are optional.

ClangSedRegExp          = ^($(ClangSedVendor))*[[:space:]]*($(ClangSedTool))[[:space:]]version[[:space:]]($(ClangSedVers))[[:space:]]\(($(ClangSedBuild))\)$$

# The sed 's' command that will match, extract, and process the
# version and build.

ClangSedCommand         = "s/$(ClangSedRegExp)/\3 (\1 \5)/gp"
ClangSedArgs            = $(ClangSedCommand)

# The grep regular expression, pattern, and arguments used to match
# the expected version.

ClangGrepRegExp         = ^($(ClangVersRegExp)[[:space:]]\(Apple*[[:space:]]*$(ClangBuildRegExp))\)$$
ClangGrepPattern        = "$(ClangGrepRegExp)"
ClangGrepArgs           = $(ClangGrepPattern)

#
# Rule transformation definitions.
#
# Everything defined here is tool-chain specific.
#

# Transform a raw assembler file into an object file.

define tool-assemble-asm
$(Verbose)$(AS) $(ASFLAGS) $(ASOutputFlag) $@ $(ASInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform an assembler with C preprocessor file into a raw assembler file.

define tool-preprocess-asm
$(Verbose)$(CPP) $(CPPFLAGS) $(CPPOutputFlag) $@ $(CPPInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform an assembler with C preprocessor file into an object file.

define tool-preprocess-and-assemble-asm
$(Verbose)$(AS) $(ASFLAGS) $(CPPFLAGS) $(ASOutputFlag) $@ $(ASInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform a C file into a preprocessed C file.

define tool-preprocess-c
$(Verbose)$(CPP) $(CPPFLAGS) $(CPPOutputFlag) $@ $(CPPInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform a C++ file into a preprocessed C++ file.

define tool-preprocess-c++
$(Verbose)$(CPP) $(CPPFLAGS) $(CPPOutputFlag) $@ $(CPPInputFlag) $(call CanonicalizePath,$(<))
endef

# While a bit of a misnomer, for human readability, these next four
# implicit rules are called "disassembling". This might be more
# accurately called "compiling"; however, that means something else to
# most. Perhaps "precompiling" would be a suitable alternative.

# Transform a C file into a raw assembler file. 

define tool-preprocess-and-compile-c
$(Verbose)$(CC) $(CPPFLAGS) $(CCFLAGS) $(CCNoAssembleFlag) $(CCOutputFlag) $@ $(CCInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform a C++ file into a raw assembler file. 

define tool-preprocess-and-compile-c++
$(Verbose)$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(CXXNoAssembleFlag) $(CXXOutputFlag) $@ $(CXXInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform an Objective C file into a raw assembler file. 

define tool-preprocess-and-compile-objective-c
$(Verbose)$(OJBCC) $(CPPFLAGS) $(CCFLAGS) $(CCNoAssembleFlag) $(CCOutputFlag) $@ $(CCInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform an Objective C++ file into a raw assembler file. 

define tool-preprocess-and-compile-objective-c++
$(Verbose)$(CXX) $(OBJCXXLanguage) $(CPPFLAGS) $(CXXFLAGS) $(CXXNoAssembleFlag) $(CXXOutputFlag) $@ $(CXXInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform a preprocessed C file into a raw assembler file.

define tool-compile-c
$(Verbose)$(CC) $(CCFLAGS) $(CCNoAssembleFlag) $(CCOutputFlag) $@ $(CCInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform a preprocessed C++ file into a raw assembler file.

define tool-compile-c++
$(Verbose)$(CXX) $(CXXFLAGS) $(CXXNoAssembleFlag) $(CXXOutputFlag) $@ $(CXXInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform a preprocessed Objective C file into a raw assembler file.

define tool-compile-objective-c
$(Verbose)$(CC) $(OBJCCLanguage) $(CCFLAGS) $(CCNoAssembleFlag) $(CCOutputFlag) $@ $(CCInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform a preprocessed Objective C++ file into a raw assembler file.

define tool-compile-objective-c++
$(Verbose)$(CXX) $(OBJCXXLanguage) $(CXXFLAGS) $(CXXNoAssembleFlag) $(CXXOutputFlag) $@ $(CXXInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform a C file into an object file.

define tool-preprocess-compile-and-assemble-c
$(Verbose)$(CC) $(CPPFLAGS) $(CCFLAGS) $(CCNoLinkFlag) $(CCOutputFlag) $@ $(CCInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform a C++ file into an object file.

define tool-preprocess-compile-and-assemble-c++
$(Verbose)$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(CXXNoLinkFlag) $(CXXOutputFlag) $@ $(CXXInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform an Objective C file into an object file.

define tool-preprocess-compile-and-assemble-objective-c
$(Verbose)$(CC) $(OBJCCLanguage) $(CPPFLAGS) $(CCFLAGS) $(CCNoLinkFlag) $(CCOutputFlag) $@ $(CCInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform an Objective C++ file into an object file.

define tool-preprocess-compile-and-assemble-objective-c++
$(Verbose)$(CXX) $(OBJCXXLanguage) $(CPPFLAGS) $(CXXFLAGS) $(CXXNoLinkFlag) $(CXXOutputFlag) $@ $(CXXInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform a preprocessed C file into an object file.

define tool-compile-and-assemble-c
$(Verbose)$(CC) $(CCFLAGS) $(CCNoLinkFlag) $(CCOutputFlag) $@ $(CCInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform a preprocessed C++ file into an object file.

define tool-compile-and-assemble-c++
$(Verbose)$(CXX) $(CXXFLAGS) $(CXXNoLinkFlag) $(CXXOutputFlag) $@ $(CXXInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform a preprocessed C file into an object file.

define tool-compile-and-assemble-objective-c
$(Verbose)$(CC) $(OBJCCLanguage) $(CCFLAGS) $(CCNoLinkFlag) $(CCOutputFlag) $@ $(CCInputFlag) $(call CanonicalizePath,$(<))
endef

# Transform a preprocessed C++ file into an object file.

define tool-compile-and-assemble-objective-c++
$(Verbose)$(CXX) $(OBJCXXLanguage) $(CXXFLAGS) $(CXXNoLinkFlag) $(CXXOutputFlag) $@ $(CXXInputFlag) $(call CanonicalizePath,$(<))
endef

define tool-depend-asm
$(Verbose)$(DEPEND) $(CPPFLAGS) $(DEPENDFLAGS) $(DEPENDOutputFlag) $@ $(DEPENDInputFlag) $(call CanonicalizePath,$(<))
endef

define tool-depend-c
$(Verbose)$(DEPEND) $(CPPFLAGS) $(DEPENDFLAGS) $(DEPENDOutputFlag) $@ $(DEPENDInputFlag) $(call CanonicalizePath,$(<))
endef

define tool-depend-c++
$(Verbose)$(DEPEND) $(CPPFLAGS) $(DEPENDFLAGS) $(DEPENDOutputFlag) $@ $(DEPENDInputFlag) $(call CanonicalizePath,$(<))
endef

define tool-depend-objective-c
$(Verbose)$(DEPEND) $(OBJCCLanguage) $(CPPFLAGS) $(DEPENDFLAGS) $(DEPENDOutputFlag) $@ $(DEPENDInputFlag) $(call CanonicalizePath,$(<))
endef

define tool-depend-objective-c++
$(Verbose)$(DEPEND) $(OBJCXXLanguage) $(CPPFLAGS) $(DEPENDFLAGS) $(DEPENDOutputFlag) $@ $(DEPENDInputFlag) $(call CanonicalizePath,$(<))
endef

# Process the generated dependencies into a form that depends both the
# objects and the dependency file itself on the dependencies.

define tool-process-depend
$(Verbose)$(SED) $(SEDFLAGS) -r -e 's#(.{1,}/$*)\.([[:graph:]]{1,})[[:space:]]*:#\1.\2 $<:#g' < $(call CanonicalizePath,$(<)) > $@
endef

# Transform a set of objects into an archive library file.

define tool-create-archive-library
$(Verbose)$(AR) $(ARFLAGS) $(AROutputFlag) $@ $(ARInputFlag) $(filter-out $($(patsubst $(LibraryPrefix)%,%,$(notdir $(basename $@)))_GENERATION),$(?))
$(Verbose)$(RANLIB) $(RANLIBFLAGS) $@
endef

# Transform a set of objects into a shared library file.

define tool-link-shared-library
$(Verbose)$(LD) $(LDFLAGS) $(LDSharedFlag) $(LDSharedNameFlag)$(@F) $(LDOutputFlag) $@ $(filter-out $(DEPLIBS) $($(patsubst $(LibraryPrefix)%,%,$(notdir $(basename $@)))_GENERATION),$^) $(call GenerateLibraryArguments,$(LDLIBS)) $(call GenerateResolveArguments,$(RESLIBS))
endef

# Transform a set of objects and libraries into an executable program.

define tool-link-program
$(Verbose)$(LD) $(LDFLAGS) $(LDOutputFlag) $@ $(filter-out $(DEPLIBS) $($(notdir $(basename $@))_GENERATION),$^) $(call GenerateLibraryArguments,$(LDLIBS)) $(call GenerateResolveArguments,$(RESLIBS))
endef

# Transform a set of objects and libraries into an image

define tool-link-image
$(Verbose)$(LD) $(LDFLAGS) $(LDOutputFlag) $@ $(filter-out $(DEPLIBS) $($(notdir $(basename $@))_GENERATION),$^) --start-group $(call GenerateLibraryArguments,$(LDLIBS)) --end-group --script=$(SCATTER) -Map=$(MAPFILE) $(call GenerateResolveArguments,$(RESLIBS))
endef

#
# Stock clang/LLVM options that Apple's clang/LLVM GCC-compatible
# front-end doesn't support
#

LangForwardPropagation  = $(Null)

#
# clang/LLVM has no equivalent to objcopy.
#

OBJCOPY                 = false

#
# Code Coverage
#

UseCodeCoverage_Y            = $(call IsYes,$(UseCodeCoverage))

LANGFLAGS_UseCodeCoverage_  := $(Null)
LANGFLAGS_UseCodeCoverage_N := $(LANGFLAGS_UseCodeCoverage_)
LANGFLAGS_UseCodeCoverage_Y  = $(ClangCoverageFlag)

LDFLAGS_UseCodeCoverage_    := $(Null)
LDFLAGS_UseCodeCoverage_N   := $(LDFLAGS_UseCodeCoverage_)
LDFLAGS_UseCodeCoverage_Y    = $(LDGCovFlag)

LANGFLAGS                   += $(LANGFLAGS_UseCodeCoverage_$(UseCodeCoverage_Y))

LDFLAGS                     += $(LDFLAGS_UseCodeCoverage_$(UseCodeCoverage_Y))

#
# Sanitizers
#

#
# Address Sanitizer
#

UseAddressSanitizer_Y            = $(call IsYes,$(UseAddressSanitizer))

LANGFLAGS_UseAddressSanitizer_  := $(Null)
LANGFLAGS_UseAddressSanitizer_N := $(LANGFLAGS_UseAddressSanitizer_)
LANGFLAGS_UseAddressSanitizer_Y  = $(call ToolAssertLanguageSanitizerFlag,$(LangSanitizeAddress))
LANGFLAGS_UseAddressSanitizer_Y += $(call ToolDeassertLanguageFlag,$(LangOmitFramePointer))
LANGFLAGS_UseAddressSanitizer_Y += $(call ToolDeassertLanguageFlag,$(LangOptimizeSiblingCalls))

LDFLAGS_UseAddressSanitizer_    := $(Null)
LDFLAGS_UseAddressSanitizer_N   := $(LDFLAGS_UseAddressSanitizer_)
LDFLAGS_UseAddressSanitizer_Y    = $(call ToolAssertLanguageSanitizerFlag,$(LangSanitizeAddress))
LDFLAGS_UseAddressSanitizer_Y   += $(call ToolDeassertLanguageFlag,$(LangOmitFramePointer))
LDFLAGS_UseAddressSanitizer_Y   += $(call ToolDeassertLanguageFlag,$(LangOptimizeSiblingCalls))

LANGFLAGS                       += $(LANGFLAGS_UseAddressSanitizer_$(UseAddressSanitizer_Y))

LDFLAGS                         += $(LDFLAGS_UseAddressSanitizer_$(UseAddressSanitizer_Y))

#
# Leak Sanitizer
#

UseLeakSanitizer_Y                 = $(call IsYes,$(UseLeakSanitizer))

LANGFLAGS_UseLeakSanitizer_       := $(Null)
LANGFLAGS_UseLeakSanitizer_N      := $(LANGFLAGS_UseLeakSanitizer_)
LANGFLAGS_UseLeakSanitizer_Y       = $(call ToolAssertLanguageSanitizerFlag,$(LangSanitizeLeak))

LDFLAGS_UseLeakSanitizer_         := $(Null)
LDFLAGS_UseLeakSanitizer_N        := $(LDFLAGS_UseLeakSanitizer_)
LDFLAGS_UseLeakSanitizer_Y         = $(call ToolAssertLanguageSanitizerFlag,$(LangSanitizeLeak))

LANGFLAGS                         += $(LANGFLAGS_UseLeakSanitizer_$(UseLeakSanitizer_Y))

LDFLAGS                           += $(LDFLAGS_UseLeakSanitizer_$(UseLeakSanitizer_Y))

#
# Thread Sanitizer
#

UseThreadSanitizer_Y               = $(call IsYes,$(UseThreadSanitizer))

LANGFLAGS_UseThreadSanitizer_     := $(Null)
LANGFLAGS_UseThreadSanitizer_N    := $(LANGFLAGS_UseThreadSanitizer_)
LANGFLAGS_UseThreadSanitizer_Y     = $(call ToolAssertLanguageSanitizerFlag,$(LangSanitizeThread))

LDFLAGS_UseThreadSanitizer_       := $(Null)
LDFLAGS_UseThreadSanitizer_N      := $(LDFLAGS_UseThreadSanitizer_)
LDFLAGS_UseThreadSanitizer_Y       = $(call ToolAssertLanguageSanitizerFlag,$(LangSanitizeThread))

LANGFLAGS                         += $(LANGFLAGS_UseThreadSanitizer_$(UseThreadSanitizer_Y))

LDFLAGS                           += $(LDFLAGS_UseThreadSanitizer_$(UseThreadSanitizer_Y))

#
# Undefined Behavior Sanitizer
#

UseUndefinedSanitizer_Y            = $(call IsYes,$(UseUndefinedSanitizer))

LANGFLAGS_UseUndefinedSanitizer_  := $(Null)
LANGFLAGS_UseUndefinedSanitizer_N := $(LANGFLAGS_UseUndefinedSanitizer_)
LANGFLAGS_UseUndefinedSanitizer_Y  = $(call ToolAssertLanguageSanitizerFlag,$(LangSanitizeUndefined))

LDFLAGS_UseUndefinedSanitizer_    := $(Null)
LDFLAGS_UseUndefinedSanitizer_N   := $(LDFLAGS_UseUndefinedSanitizer_)
LDFLAGS_UseUndefinedSanitizer_Y    = $(call ToolAssertLanguageSanitizerFlag,$(LangSanitizeUndefined))

LANGFLAGS                         += $(LANGFLAGS_UseUndefinedSanitizer_$(UseUndefinedSanitizer_Y))

LDFLAGS                           += $(LDFLAGS_UseUndefinedSanitizer_$(UseUndefinedSanitizer_Y))
