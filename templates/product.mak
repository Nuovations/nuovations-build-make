##
#    @file
#      This is the @PRODUCT@ product-specific makefile for @PROJECT@.
#

#
# The target operating system.
#
# Set this to something other than $(HostOS) for cross-compilation
# targets.
#
TargetOS                = $(HostOS)

#
# The canonical target architecture, vendor and operating system
# tuple.
#
# Set this to something other than $(HostTuple) for cross-compilation
# targets.
#
TargetTuple             = $(HostTuple)

#
# The tool vendor, chain and version to use.
#
ToolVendor              = gnu
ToolProduct             = gcc
ToolVersion             = x.x.x

#
# Processor- and architecture-specific machine and language flags.
#
# Set (or remove) these as appropriate for your product and project.
#
MACHFLAGS               += $(Null)
LANGFLAGS               += $(Null)

CPPOPTFLAGS             += $(MACHFLAGS)

CCLANGSTDFLAGS          += $(call ToolAssertLanguageStandardFlag,$(LangStandardC2011))
CXXLANGSTDFLAGS         += $(call ToolAssertLanguageStandardFlag,$(LangStandardCxx2014))

CCOPTFLAGS              += $(CCLANGSTDFLAGS) $(CCLANGFLAGS) $(LANGFLAGS)

CXXOPTFLAGS             += $(CXXLANGSTDFLAGS) $(CXXLANGFLAGS) $(LANGFLAGS)

LDFLAGS                 += $(Null)

#
# The product- or project-specific top-level makefile to which make
# goals will be dispatched for this product and all of its
# configurations.
#
# This may be a singular project-wide makefile or a product-specific
# makefile.
#
BuildProductTopMakefile := $(BuildRoot)/@PROJECT@.mak

