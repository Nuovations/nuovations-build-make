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
#      This file is the make header for all common
#      (i.e. non-toolchain-specific) rules used in the project.
#

# Suffixes we define, use and support.

DependencySuffixes              = $(BaseDependSuffix) $(PatchedDependSuffix)
ObjectSuffixes                  = $(StaticObjectSuffix) $(SharedObjectSuffix)
LibrarySuffixes                 = $(ArchiveLibrarySuffix) $(SharedLibrarySuffix)
AssemblerSuffixes               = .S .s .s79
CSuffixes                       = .c
CPlusPlusSuffixes               = .C .cc .cp .cpp .CPP .cxx .c++
ObjectiveCSuffixes              = .m
ObjectiveCPlusPlusSuffixes      = .mm
PreprocessedSuffixes            = $(addsuffix .i,$(CSuffixes) $(CPlusPlusSuffixes) $(ObjectiveCSuffixes) $(ObjectiveCPlusPlusSuffixes))

# Reset handled suffixes and set them to ones we want to handle.

.SUFFIXES:
.SUFFIXES: $(AssemblerSuffixes) $(DependencySuffixes) $(CSuffixes) $(CPlusPlusSuffixes) $(LibrarySuffixes) $(ObjectiveCSuffixes) $(ObjectiveCPlusPlusSuffixes) $(ObjectSuffixes) $(PreprocessedSuffixes)

#
# Rule transformation definitions.
#
# Everything defined here is and must remain generic and tool-chain
# agnostic. Anything that relies on tool-chain specific behavior must
# be abstracted and referenced through a variable or macro call.
#

ArchiveVerb             = Archiving
AssembleVerb            = Assembling
PreprocessVerb          = Preprocessing
LinkVerb                = Linking
CompileVerb             = Compiling
DependVerb              = Depending
DisassembleVerb         = Disassembling
ExecuteVerb             = Executing
TranslateVerb           = Translating
SignVerb                = Signing

# Transform a raw assembler file into an object file.

define assemble-asm
$(Echo) "$(AssembleVerb) ($(ASName)) \"$<\""
$(tool-assemble-asm)
endef

# Transform an assembler with C preprocessor file into a raw assembler file.

define preprocess-asm
$(Echo) "$(PreprocessVerb) ($(CPPName)) \"$<\""
$(tool-preprocess-asm)
endef

# Transform an assembler with C preprocessor file into an object file.

define preprocess-and-assemble-asm
$(Echo) "$(AssembleVerb) ($(ASName)) \"$<\""
$(tool-preprocess-and-assemble-asm)
endef

# Transform a C file into a preprocessed C file.

define preprocess-c
$(Echo) "$(PreprocessVerb) ($(CPPName)) \"$<\""
$(tool-preprocess-c)
endef

# Transform a C++ file into a preprocessed C++ file.

define preprocess-c++
$(Echo) "$(PreprocessVerb) ($(CPPName)) \"$<\""
$(tool-preprocess-c++)
endef

# Transform an Objective C file into a preprocessed Objective C file.

define preprocess-objective-c
$(Echo) "$(PreprocessVerb) ($(CPPName)) \"$<\""
$(tool-preprocess-objective-c)
endef

# Transform an Objective C++ file into a preprocessed Objective C++ file.

define preprocess-objective-c++
$(Echo) "$(PreprocessVerb) ($(CPPName)) \"$<\""
$(tool-preprocess-objective-c++)
endef

# While a bit of a misnomer, for human readability, these next four
# implicit rules are called "disassembling". This might be more
# accurately called "compiling"; however, that means something else to
# most. Perhaps "precompiling" or "preassembling" would be suitable
# alternatives.

# Transform a C file into a raw assembler file. 

define preprocess-and-compile-c
$(Echo) "$(DisassembleVerb) ($(CCName)) \"$<\""
$(tool-preprocess-and-compile-c)
endef

# Transform a C++ file into a raw assembler file. 

define preprocess-and-compile-c++
$(Echo) "$(DisassembleVerb) ($(CXXName)) \"$<\""
$(tool-preprocess-and-compile-c++)
endef

# Transform an Objective C file into a raw assembler file. 

define preprocess-and-compile-objective-c
$(Echo) "$(DisassembleVerb) ($(CCName)) \"$<\""
$(tool-preprocess-and-compile-objective-c)
endef

# Transform an Objective C++ file into a raw assembler file. 

define preprocess-and-compile-objective-c++
$(Echo) "$(DisassembleVerb) ($(CXXName)) \"$<\""
$(tool-preprocess-and-compile-objective-c++)
endef

# Transform a preprocessed C file into a raw assembler file.

define compile-c
$(Echo) "$(DisassembleVerb) ($(CCName)) \"$<\""
$(tool-compile-c)
endef

# Transform a preprocessed C++ file into a raw assembler file.

define compile-c++
$(Echo) "$(DisassembleVerb) ($(CXXName)) \"$<\""
$(tool-compile-c++)
endef

# Transform a preprocessed Objective C file into a raw assembler file.

define compile-objective-c
$(Echo) "$(DisassembleVerb) ($(CCName)) \"$<\""
$(tool-compile-objective-c)
endef

# Transform a preprocessed Objective C++ file into a raw assembler file.

define compile-objective-c++
$(Echo) "$(DisassembleVerb) ($(CXXName)) \"$<\""
$(tool-compile-objective-c++)
endef

# Transform a C file into an object file.

define preprocess-compile-and-assemble-c
$(Echo) "$(CompileVerb) ($(CCName)) \"$<\""
$(tool-preprocess-compile-and-assemble-c)
endef

# Transform a C++ file into an object file.

define preprocess-compile-and-assemble-c++
$(Echo) "$(CompileVerb) ($(CXXName)) \"$<\""
$(tool-preprocess-compile-and-assemble-c++)
endef

# Transform an Objective C file into an object file.

define preprocess-compile-and-assemble-objective-c
$(Echo) "$(CompileVerb) ($(CCName)) \"$<\""
$(tool-preprocess-compile-and-assemble-objective-c)
endef

# Transform an Objective C++ file into an object file.

define preprocess-compile-and-assemble-objective-c++
$(Echo) "$(CompileVerb) ($(CXXName)) \"$<\""
$(tool-preprocess-compile-and-assemble-objective-c++)
endef

# Transform a preprocessed C file into an object file.

define compile-and-assemble-c
$(Echo) "$(CompileVerb) ($(CCName)) \"$<\""
$(tool-compile-and-assemble-c)
endef

# Transform a preprocessed C++ file into an object file.

define compile-and-assemble-c++
$(Echo) "$(CompileVerb) ($(CXXName)) \"$<\""
$(tool-compile-and-assemble-c++)
endef

# Transform a preprocessed Objective C file into an object file.

define compile-and-assemble-objective-c
$(Echo) "$(CompileVerb) ($(CCName)) \"$<\""
$(tool-compile-and-assemble-objective-c)
endef

# Transform a preprocessed Objective C++ file into an object file.

define compile-and-assemble-objective-c++
$(Echo) "$(CompileVerb) ($(CXXName)) \"$<\""
$(tool-compile-and-assemble-objective-c++)
endef

# Transform an assembler with C preprocessor file into a dependency file.

define depend-asm
$(Echo) "$(DependVerb) ($(DEPENDName)) \"$<\""
$(tool-depend-asm)
endef

# Transform a C file into a dependency file.

define depend-c
$(Echo) "$(DependVerb) ($(DEPENDName)) \"$<\""
$(tool-depend-c)
endef

# Transform a C++ file into a dependency file.

define depend-c++
$(Echo) "$(DependVerb) ($(DEPENDName)) \"$<\""
$(tool-depend-c++)
endef

# Transform an Objective C file into a dependency file.

define depend-objective-c
$(Echo) "$(DependVerb) ($(DEPENDName)) \"$<\""
$(tool-depend-objective-c)
endef

# Transform an Objective C++ file into a dependency file.

define depend-objective-c++
$(Echo) "$(DependVerb) ($(DEPENDName)) \"$<\""
$(tool-depend-objective-c++)
endef

# Transform a dependency file into a processed dependency file.

define process-depend
$(Echo) "Processing dependencies for \"$(<F)\""
$(tool-process-depend)
endef

# XXX - Move this somewhere else

ResultsPath                     = $(notdir $(1))

# Transform a set of objects into an archive library file.

define create-archive-library
$(Echo) "$(ArchiveVerb) ($(ARName)) \"$(call ResultsPath,$(@))\""
$(tool-create-archive-library)
endef

# Transform a set of objects into a shared library file.

define link-shared-library
$(Echo) "$(LinkVerb) ($(LDName)) \"$(call ResultsPath,$(@))\""
$(tool-link-shared-library)
endef

# Transform a set of objects and libraries into an executable program.

define link-program
$(Echo) "$(LinkVerb) ($(LDName)) \"$(call ResultsPath,$(@))\""
$(tool-link-program)
endef

# Execute program, providing all required loader search paths.

define execute-program
$(Echo) "$(ExecuteVerb) \"$(call ResultsPath,$<)\""
$(Verbose)export $(LoaderSearchPath)=$(subst $(Space),:,$(dir $(LDLIBS) $(RESLIBS)))$(addprefix :,$($(LoaderSearchPath))) && $(<) $($(<F)_ARGUMENTS)
endef

#
# For the purposes of using it as a strongly-typed C compiler, the
# make file author can select on a make file-by-make file basis to
# treat and transform C source files as though they were C++ source
# files by defining 'TransformCAsCPlusPlus' to 'Yes'.
#

ifdef TransformCAsCPlusPlus
depend-c-or-c++                                                 = $(depend-c++)
preprocess-c-or-c++                                             = $(preprocess-c++)
preprocess-objective-c-or-objective-c++                         = $(preprocess-objective-c++)
preprocess-and-compile-c-or-c++                                 = $(preprocess-and-compile-c++)
preprocess-and-compile-objective-c-or-objective-c++             = $(preprocess-and-compile-objective-c++)
preprocess-compile-and-assemble-c-or-c++                        = $(preprocess-compile-and-assemble-c++)
preprocess-compile-and-assemble-objective-c-or-objective-c++    = $(preprocess-compile-and-assemble-objective-c++)
compile-c-or-c++                                                = $(compile-c++)
compile-objective-c-or-objective-c++                            = $(compile-objective-c++)
compile-and-assemble-c-or-c++                                   = $(compile-and-assemble-c++)
compile-and-assemble-objective-c-or-objective-c++               = $(compile-and-assemble-objective-c++)
else
depend-c-or-c++                                                 = $(depend-c)
preprocess-c-or-c++                                             = $(preprocess-c)
preprocess-objective-c-or-objective-c++                         = $(preprocess-objective-c)
preprocess-and-compile-c-or-c++                                 = $(preprocess-and-compile-c)
preprocess-and-compile-objective-c-or-objective-c++             = $(preprocess-and-compile-objective-c)
preprocess-compile-and-assemble-c-or-c++                        = $(preprocess-compile-and-assemble-c)
preprocess-compile-and-assemble-objective-c-or-objective-c++    = $(preprocess-compile-and-assemble-objective-c)
compile-c-or-c++                                                = $(compile-c)
compile-objective-c-or-objective-c++                            = $(compile-objective-c)
compile-and-assemble-c-or-c++                                   = $(compile-and-assemble-c)
compile-and-assemble-objective-c-or-objective-c++               = $(compile-and-assemble-objective-c)
endif # TransformCAsCPlusPlus

#
# Implicit rules
#

#$(call GenerateDependPaths,%$(BaseDependSuffix)): %.S | $(DependDirectory)
#	$(depend-asm)
#
#$(call GenerateDependPaths,%$(BaseDependSuffix)): %.c | $(DependDirectory)
#	$(depend-c-or-c++)
#
#$(call GenerateDependPaths,%$(BaseDependSuffix)): %.cc | $(DependDirectory)
#	$(depend-c++)
#
#$(call GenerateDependPaths,%$(BaseDependSuffix)): %.cp | $(DependDirectory)
#	$(depend-c++)
#
#$(call GenerateDependPaths,%$(BaseDependSuffix)): %.cxx | $(DependDirectory)
#	$(depend-c++)
#
#$(call GenerateDependPaths,%$(BaseDependSuffix)): %.cpp | $(DependDirectory)
#	$(depend-c++)
#
#$(call GenerateDependPaths,%$(BaseDependSuffix)): %.CPP | $(DependDirectory)
#	$(depend-c++)
#
#$(call GenerateDependPaths,%$(BaseDependSuffix)): %.c++ | $(DependDirectory)
#	$(depend-c++)
#
#$(call GenerateDependPaths,%$(BaseDependSuffix)): %.C | $(DependDirectory)
#	$(depend-c++)

#$(call GenerateDependPaths,%$(PatchedDependSuffix)): $(call GenerateDependPaths,%$(BaseDependSuffix)) | $(DependDirectory)
#	$(process-depend)

%.s: %.S
	$(preprocess-asm)

%.s: %.s79
	$(preprocess-asm)

$(call GenerateBuildPaths,%$(StaticObjectSuffix)): %.s | $(DependDirectory) $(BuildDirectory)
	$(assemble-asm)

$(call GenerateBuildPaths,%$(StaticObjectSuffix)): %.S | $(DependDirectory) $(BuildDirectory)
	$(preprocess-and-assemble-asm)

$(call GenerateBuildPaths,%$(StaticObjectSuffix)): %.s79 | $(DependDirectory) $(BuildDirectory)
	$(preprocess-and-assemble-asm)

%.c.i: %.c
	$(preprocess-c-or-c++)

%.m.i: %.m
	$(preprocess-objective-c-or-objective-c++)

%.cc.i: %.cc
	$(preprocess-c++)

%.cp.i: %.cp
	$(preprocess-c++)

%.cxx.i: %.cxx
	$(preprocess-c++)

%.cpp.i: %.cpp
	$(preprocess-c++)

%.CPP.i: %.CPP
	$(preprocess-c++)

%.c++.i: %.c++
	$(preprocess-c++)

%.C.i: %.C
	$(preprocess-c++)

%.mm.i: %.mm
	$(preprocess-objective-c++)

%.s: %.c
	$(preprocess-and-compile-c-or-c++)

%.s: %.m
	$(preprocess-and-compile-objective-c-or-objective-c++)

%.s: %.cc
	$(preprocess-and-compile-c++)

%.s: %.cp
	$(preprocess-and-compile-c++)

%.s: %.cxx
	$(preprocess-and-compile-c++)

%.s: %.cpp
	$(preprocess-and-compile-c++)

%.s: %.CPP
	$(preprocess-and-compile-c++)

%.s: %.c++
	$(preprocess-and-compile-c++)

%.s: %.C
	$(preprocess-and-compile-c++)

%.s: %.mm
	$(preprocess-and-compile-objective-c++)

%.s: %.c.i
	$(compile-c-or-c++)

%.s: %.m.i
	$(compile-objective-c-or-objective-c++)

%.s: %.cc.i
	$(compile-c++)

%.s: %.cp.i
	$(compile-c++)

%.s: %.cxx.i
	$(compile-c++)

%.s: %.cpp.i
	$(compile-c++)

%.s: %.CPP.i
	$(compile-c++)

%.s: %.c++.i
	$(compile-c++)

%.s: %.C.i
	$(compile-c++)

%.s: %.mm.i
	$(compile-objective-c++)

#
# Shared and Static Object Implicit Pattern Rules
#

# Unconditionally add the shared object flag for shared objects.

$(call GenerateBuildPaths,%$(SharedObjectSuffix)): CCFLAGS  += $(CCPICFlag)
$(call GenerateBuildPaths,%$(SharedObjectSuffix)): CXXFLAGS += $(CXXPICFlag)

# Only add the shared object flag for static objects if 'EnableShared' is asserted.

EnableShared_Y           = $(call IsYes,$(EnableShared))

CCFLAGS_EnableShared_   := $(Null)
CCFLAGS_EnableShared_N  := $(CCFLAGS_EnableShared_)
CCFLAGS_EnableShared_Y   = $(CCPICFlag)

CXXFLAGS_EnableShared_  := $(Null)
CXXFLAGS_EnableShared_N := $(CXXFLAGS_EnableShared_)
CXXFLAGS_EnableShared_Y  = $(CXXPICFlag)

$(call GenerateBuildPaths,%$(StaticObjectSuffix)): CCFLAGS  += $(CCFLAGS_EnableShared_$(EnableShared_Y))
$(call GenerateBuildPaths,%$(StaticObjectSuffix)): CXXFLAGS += $(CXXFLAGS_EnableShared_$(EnableShared_Y))

# Handle input source files in the makefile directory with output in the build directory.

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.c.i | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-c-or-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.m.i | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-objective-c-or-objective-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.cc.i | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.cp.i | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.cxx.i | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.cpp.i | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.CPP.i | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.c++.i | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.C.i | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.mm.i | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-objective-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.c | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-c-or-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.m | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-objective-c-or-objective-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.cc | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.cp | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.cxx | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.cpp | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.CPP | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.c++ | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.C | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): %.mm | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-objective-c++)

# Handle auto-generated input source files with output in the same build directory.

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.c.i) | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-c-or-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.m.i) | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-objective-c-or-objective-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.cc.i) | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.cp.i) | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.cxx.i) | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.cpp.i) | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.CPP.i) | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.c++.i) | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.C.i) | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.mm.i) | $(DependDirectory) $(BuildDirectory)
	$(compile-and-assemble-objective-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.c) | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-c-or-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.m) | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-objective-c-or-objective-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.cc) | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.cp) | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.cxx) | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.cpp) | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.CPP) | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.c++) | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.C) | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-c++)

$(call GenerateBuildPaths,%$(SharedObjectSuffix) %$(StaticObjectSuffix)): $(call GenerateBuildPaths,%.mm) | $(DependDirectory) $(BuildDirectory)
	$(preprocess-compile-and-assemble-objective-c++)

#
# Explicit targets
#

.PHONY: all local-all
all: recursive local-all

.PHONY: prepare local-prepare
prepare: recursive local-prepare

ifeq ($(TargetTuple),$(HostTuple))
.PHONY: execute local-execute
execute: recursive local-execute
endif

# ARCHIVES and LIBRARIES are phony because they will never name a
# real, named target, but are rather the core of an archive or shared
# library name (e.g. lib<name>.a or lib<name>.so).

.PHONY: $(ARCHIVES) $(LIBRARIES)

# Define comprehensively what targets will be made by the 'local-all'
# rule and do so at this stage such that dependencies can be generated
# and specified as a goal for 'local-all'.

TARGETS	+= $(ARCHIVES) $(LIBRARIES) $(PROGRAMS)

# DEPEND_template <target>
#
# This instantiates a template for defining dependencies for the
# specified target. These dependencies are, in turn, accreted into the
# list of all dependencies for the current make file.

define DEPEND_template
$(1)_DEPENDS = $$(call GenerateBaseDependPaths,$$($(1)_SOURCES))
DEPENDS += $$($(1)_DEPENDS)
endef # DEPEND_template

$(foreach target,$(TARGETS),$(eval $(call DEPEND_template,$(target))))

define HEADER_source
$(foreach spec,$(1),$(firstword $(subst :, ,$(spec))))
endef # HEADER_source

define HEADER_result
$(foreach spec,$(1),$(call Slashify,$(ResultDirectory))$(lastword $(subst :, ,$(1))))
endef # HEADER_result

# HEADER_template <source>[:<result>]
#
# This instantiates a template for defining header dependency for the
# given header specification and updates the HEADERS variable.

define HEADER_template
$$(call HEADER_result,$(1)): $$(call HEADER_source,$(1)) | $(ResultDirectory)
HEADERS += $$(call HEADER_result,$(1))
endef # HEADER_template

$(foreach target,$(TARGETS),$(foreach header,$($(target)_HEADERS),$(eval $(call HEADER_template,$(header)))))

HeaderTargets = $(HEADERS)
$(HeaderTargets):
	$(install-result)

# Always include in the private 'local-all' target a command that'll
# always succeed to avoid "make[n]: Nothing to be done for `all'." 
# messages for make files that do not have an 'all' target with
# commands.

local-all: $(TARGETS) $(DEPENDS) $(HEADERS)
	$(Quiet)true

local-prepare: $(BuildDirectory) $(ResultDirectory) $(PrepareTargets) $(HEADERS)
	$(Quiet)true

$(foreach target,$(PrepareTargets),$(eval $(call DEPEND_template,$(target))))

.PHONY: recursive
recursive: $(SubMakefiles)

.PHONY: force
force:

# make-submakefile <makefile>
#
# This invokes a recursive make, using job-safe '+' and $(MAKE)
# semantics, on the specified absolute or relative makefile path,
# 'makefile', with the current make command goals.

define make-submakefile
$(Echo) "Processing \"$(call GenerateBuildRootEllipsedPath,$(if $(call IsAbsolutePath,$(1)),$(1),$(BuildCurrentDirectory)/$(1)))\""
+$(Verbose)$(MAKE) -C "$(dir $(1))" -f "$(notdir $(1))" $(MAKECMDGOALS)
endef # make-submakefile

# make-submakefile-target
#
# This invokes a recursive make, using job-safe '+' and $(MAKE)
# semantics, on the specified absolute or relative makefile target
# path, $(@), with the current make command goals.

define make-submakefile-target
$(call make-submakefile,$(@))
endef # make-submakefile-target

# SubMakefiles
#
# 'SubMakefiles' is a list of absolute or relative makefile paths for
# which recursive make will be invoked with the current make command
# goals.
#
# Ordering of 'SubMakefiles' may be achieved by specifying explicit
# dependencies among these makefiles (or other, "foreign" makefiles)
# by making make-style normal or order-only prequisite
# expressions. The target of these prerequisite expressions should
# then be added to 'SubMakefileDependencies'.
#
# Since 'SubMakefiles' are real, existent makefile files that
# ostensibly always exist, they employ the 'force' prerequisite to
# ensure they are always out-of-date and the submake is dispatched.

# SubMakefileDependencies
#
# 'SubMakefileDependencies' is a list of absolute or relative
# prerequisite makefile paths for which recursive make needs to be
# invoked with the current make command goals to satisfy the
# dependency prerequisites of 'SubMakefiles'.
#
# Since 'SubMakefileDependencies' are real, existent makefiles that
# ostensibly always exist, they employ the 'force' prerequisite to
# ensure they are always out-of-date and the submake is dispatched.

ifdef SubMakefiles
# Depulicate 'SubMakefiles' and 'SubMakefileDependencies' to avoid
# "target '<target>' given more than once in the same rule" warnings
# from make.

_UniqueRecursiveMakeTargets = $(call Unique,$(SubMakefiles) $(SubMakefileDependencies))

$(_UniqueRecursiveMakeTargets): force
	$(make-submakefile-target)
endif # SubMakefiles

# ASSIGNMENT_template <target> <what> <variable> <operation>
#
# This template instantiates a target assignment of:
#
# $(<target><what>): <variable> <operation> <target>_<variable>

define ASSIGNMENT_template
$($(1)$(2)): $(3) $(4) $($(1)_$(3))
endef # ASSIGNMENT_template

#
# Archive library target instantiation
#

ifdef ARCHIVES
ArchiveTargets = $(call GenerateArchiveLibraryPaths,$(ARCHIVES))

# ARCHIVE_template <target>
#
# This template instantiates a template for making the specified
# archive library target.

define ARCHIVE_template
SOURCES += $$($(1)_SOURCES)
$(1)_SOBJECTS += $$(call GenerateStaticObjectPaths,$$($(1)_SOURCES))
$$($(1)_SOBJECTS): | $$(call HEADER_result,$$($(1)_HEADERS))
$(1)_INCLUDES += $$(sort $$(dir $$($(1)_SOURCES)))
OBJECTS += $$($(1)_SOBJECTS)

$(1)_ARCHIVE := $(1)
$(1)_STARGET := $$(call GenerateArchiveLibraryPaths,$(1))

$(1): $$($(1)_STARGET)
$$($(1)_STARGET): $$($(1)_SOBJECTS)

$(1)_GENERATION := $$(call GenerateGenerationPaths,$(1))
GENERATIONS += $$($(1)_GENERATION)
$$($(1)_GENERATION): $$($(1)_SOBJECTS)
$$($(1)_STARGET): $$($(1)_GENERATION)

# These conditional assignments are per object.
$$(call ASSIGNMENT_template,$(1),_DEPENDS,CPPFLAGS,+=)
$$(call ASSIGNMENT_template,$(1),_DEPENDS,INCLUDES,+=)
$$(call ASSIGNMENT_template,$(1),_DEPENDS,DEFINES,+=)
$$(call ASSIGNMENT_template,$(1),_DEPENDS,UNDEFINES,+=)
$$(call ASSIGNMENT_template,$(1),_SOBJECTS,CPPFLAGS,+=)
$$(call ASSIGNMENT_template,$(1),_SOBJECTS,INCLUDES,+=)
$$(call ASSIGNMENT_template,$(1),_SOBJECTS,DEFINES,+=)
$$(call ASSIGNMENT_template,$(1),_SOBJECTS,UNDEFINES,+=)
$$(call ASSIGNMENT_template,$(1),_SOBJECTS,WARNINGS,+=)
endef # ARCHIVE_template

$(foreach archive,$(ARCHIVES),$(eval $(call ARCHIVE_template,$(archive))))

$(ArchiveTargets):
	$(create-archive-library)
endif # ARCHIVES

#
# Shared library target instantiation
#

ifdef LIBRARIES
LibraryTargets = $(call GenerateSharedLibraryPaths,$(LIBRARIES))

# LIBRARY_template <target>
#
# This template instantiates a template for making the specified
# shared library target.

define LIBRARY_template
SOURCES += $$($(1)_SOURCES)
$(1)_DOBJECTS += $$(call GenerateSharedObjectPaths,$$($(1)_SOURCES))
$$($(1)_DOBJECTS): | $$(call HEADER_result,$$($(1)_HEADERS))
$(1)_INCLUDES += $$(sort $$(dir $$($(1)_SOURCES)))
OBJECTS += $$($(1)_DOBJECTS)

$(1)_LIBRARY := $(1)
$(1)_DTARGET := $$(call GenerateSharedLibraryPaths,$(1))

$(1): $$($(1)_DTARGET)
$$($(1)_DTARGET): $$($(1)_DOBJECTS)
$$($(1)_DTARGET): $$($(1)_DEPLIBS)

$(1)_GENERATION := $$(call GenerateGenerationPaths,$(1))
GENERATIONS += $$($(1)_GENERATION)
$$($(1)_GENERATION): $$($(1)_DOBJECTS)
$$($(1)_DTARGET): $$($(1)_GENERATION)

# These conditional assignments are per object.
$$(call ASSIGNMENT_template,$(1),_DEPENDS,CPPFLAGS,+=)
$$(call ASSIGNMENT_template,$(1),_DEPENDS,INCLUDES,+=)
$$(call ASSIGNMENT_template,$(1),_DEPENDS,DEFINES,+=)
$$(call ASSIGNMENT_template,$(1),_DEPENDS,UNDEFINES,+=)
$$(call ASSIGNMENT_template,$(1),_DOBJECTS,CPPFLAGS,+=)
$$(call ASSIGNMENT_template,$(1),_DOBJECTS,INCLUDES,+=)
$$(call ASSIGNMENT_template,$(1),_DOBJECTS,DEFINES,+=)
$$(call ASSIGNMENT_template,$(1),_DOBJECTS,UNDEFINES,+=)
$$(call ASSIGNMENT_template,$(1),_DOBJECTS,WARNINGS,+=)

# These conditional assignments are per target.
$$(call ASSIGNMENT_template,$(1),_DTARGET,DEPLIBS,+=)
$$(call ASSIGNMENT_template,$(1),_DTARGET,LDLIBS,+=)
$$(call ASSIGNMENT_template,$(1),_DTARGET,RESLIBS,+=)
endef # LIBRARY_template

$(foreach library,$(LIBRARIES),$(eval $(call LIBRARY_template,$(library))))

$(LibraryTargets):
	$(link-shared-library)
endif # LIBRARIES

#
# Program target instantiation
#

ifdef PROGRAMS
ProgramTargets = $(call GenerateProgramPaths,$(PROGRAMS))
ifeq ($(TargetTuple),$(HostTuple))
ExecuteTargets = $(addprefix execute-,$(PROGRAMS))
endif

# PROGRAM_template <target>
#
# This template instantiates a template for making the specified
# program target.

define PROGRAM_template
SOURCES += $$($(1)_SOURCES)
$(1)_POBJECTS += $$(call GenerateStaticObjectPaths,$$($(1)_SOURCES))
$$($(1)_POBJECTS): | $$(call HEADER_result,$$($(1)_HEADERS))
$(1)_INCLUDES += $$(sort $$(dir $$($(1)_SOURCES)))
OBJECTS += $$($(1)_POBJECTS)

$(1)_PROGRAM := $(1)
$(1)_PTARGET := $$(call GenerateProgramPaths,$(1))

$(1): $$($(1)_PTARGET)
$$($(1)_PTARGET): $$($(1)_POBJECTS)
$$($(1)_PTARGET): $$($(1)_DEPLIBS)

$(1)_GENERATION := $$(call GenerateGenerationPaths,$(1))
GENERATIONS += $$($(1)_GENERATION)
$$($(1)_GENERATION): $$($(1)_POBJECTS)
$$($(1)_PTARGET): $$($(1)_GENERATION)

ifeq ($(TargetTuple),$(HostTuple))
$(1)_ETARGET := $(addprefix execute-,$(1))
$$($(1)_ETARGET): $$($(1)_PTARGET)
endif

# These conditional assignments are per object.
$$(call ASSIGNMENT_template,$(1),_DEPENDS,CPPFLAGS,+=)
$$(call ASSIGNMENT_template,$(1),_DEPENDS,INCLUDES,+=)
$$(call ASSIGNMENT_template,$(1),_DEPENDS,DEFINES,+=)
$$(call ASSIGNMENT_template,$(1),_DEPENDS,UNDEFINES,+=)
$$(call ASSIGNMENT_template,$(1),_POBJECTS,CPPFLAGS,+=)
$$(call ASSIGNMENT_template,$(1),_POBJECTS,INCLUDES,+=)
$$(call ASSIGNMENT_template,$(1),_POBJECTS,DEFINES,+=)
$$(call ASSIGNMENT_template,$(1),_POBJECTS,UNDEFINES,+=)
$$(call ASSIGNMENT_template,$(1),_POBJECTS,WARNINGS,+=)

# These conditional assignments are per target.
$$(call ASSIGNMENT_template,$(1),_PTARGET,LDFLAGS,+=)
$$(call ASSIGNMENT_template,$(1),_PTARGET,DEPLIBS,+=)
$$(call ASSIGNMENT_template,$(1),_PTARGET,LDLIBS,+=)
$$(call ASSIGNMENT_template,$(1),_PTARGET,RESLIBS,+=)

ifeq ($(TargetTuple),$(HostTuple))
# These conditional assignments are per target.
$$(call ASSIGNMENT_template,$(1),_ETARGET,LDLIBS,+=)
$$(call ASSIGNMENT_template,$(1),_ETARGET,RESLIBS,+=)
endif

endef # PROGRAM_template

$(foreach program,$(PROGRAMS),$(eval $(call PROGRAM_template,$(program))))

$(ProgramTargets):
	$(link-program)

ifeq ($(TargetTuple),$(HostTuple))

.PHONY: local-execute $(ExecuteTargets)

local-execute: $(ExecuteTargets)

$(ExecuteTargets):
	$(execute-program)

endif

endif # PROGRAMS

PatchedDependPaths      = $(DEPENDS)
BaseDependPaths         = $(call GenerateBaseDependNames,$(PatchedDependPaths))

DependPaths             = $(BaseDependPaths) $(PatchedDependPaths)

BuildPaths              += $(OBJECTS)
BuildPaths		+= $(GENERATIONS)

ResultPaths             += $(ArchiveTargets) $(LibraryTargets) $(ProgramTargets) $(ImageTargets)

# These are what post.mak will rely upon to include in all makefiles
# that include post.mak.

Dependencies            = $(PatchedDependPaths)

#
# Check targets (checking build sanity, tool versions, environment
# configuration, etc.)
#

.PHONY: check check-local check-recursive
check: check-local check-recursive

check-local: check-tools

check-recursive:

#
# Macro for checking tool versions
#

ifndef NoCheckToolVersions

define check-tool-version
	$(Echo) -n "Checking $(ToolDescription) version..."
	$(Verbose)version=`$(ToolPath) $(ToolVersionArgs) 2>&1 | $(SED) $(SEDFLAGS) -n -e $(ToolSedArgs)` ; \
	echo $$version; \
	echo $$version | grep -q $(ToolGrepArgs); \
	if [ $$? -ne 0 ]; then \
		echo "Unexpected version for \"$(ToolPath)\"!"; \
		false; \
	fi
endef # check-tool-version

else # NoCheckToolVersions

define check-tool-version
endef

endif # NoCheckToolVersions

check-tools: maybe-check-tools

.PHONY: maybe-check-tools
maybe-check-tools: maybe-check-make \
	maybe-check-assemblers \
	maybe-check-binutils \
	maybe-check-compilers \
	maybe-check-preprocessors

.PHONY: maybe-check-make
maybe-check-make: do-check-make

.PHONY: do-check-make
do-check-make: ToolPath=$(MAKE)
do-check-make: ToolVersionArgs="--version"
do-check-make: ToolDescription="make"
do-check-make: ToolSedArgs=$(MAKESedArgs)
do-check-make: ToolGrepArgs=$(MAKEGrepArgs)
do-check-make:
	$(check-tool-version)

#
# Directory targets
#

# The following rules are collapsed into one since they
# might all effectively be the same directory.

$(DependDirectory) $(BuildDirectory) $(ResultDirectory):
	$(create-directory)

# Since the timestamp on directories change every time a file is
# added, specify the parent directory of these paths as an order-only
# prerequisite.

$(DependPaths): | $(DependDirectory)

$(BuildPaths): | $(BuildDirectory)

$(ResultPaths): | $(ResultDirectory)

#
# Generation targets
#

$(GENERATIONS):
	$(call UpdateGenerationPath,$(@))

#
# Clean targets
#

CleanPaths      += $(DependPaths) \
                   $(BuildPaths) \
                   $(ResultPaths)

.PHONY: clean
clean: recursive local-clean

local-clean:
	$(Echo) "Cleaning in \"$(call GenerateBuildRootEllipsedPath,$(BuildCurrentDirectory))\""
	-$(Verbose)$(RM) $(RMFLAGS) $(CleanPaths)
	-$(Verbose)$(RM) $(RMFLAGS) *~ "#"* *.i

#
# DistClean targets
#

.PHONY: distclean
distclean: recursive local-distclean

#
.PHONY: local-distclean
local-distclean: clean
    # Delete empty subdirectories in $(DependDirectory), $(BuildDirectory), and $(ResultDirectory),
    # the directory itself and it's ancestors if they are empty.  Don't fail if any
    # of these fail (can happen when there are sub Makefiles in the same folder, which can
    # result in multiple attempts to rmdir a folder in parallel builds).
	$(Echo) "DistCleaning in \"$(call GenerateBuildRootEllipsedPath,$(BuildCurrentDirectory))\""
	-$(Verbose)$(RM) $(RMFLAGS) $(DistCleanPaths)
	$(call remove-empty-directory-and-ancestors, $(BuildDirectory))
	$(call remove-empty-directory-and-ancestors, $(DependDirectory))
	$(call remove-empty-directory-and-ancestors, $(ResultDirectory))

include post/rules/help.mak
include post/rules/print.mak
include post/rules/pretty.mak
include post/rules/tps.mak

include target/tools/$(ToolTuple)/rules.mak
