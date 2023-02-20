Nuovations Build Requirements
=============================

# Introduction

This document enumerates the requirements, reasons, and motivations
for the Nuovations Build system.

# Background

The software development world, particularly for C- or C++-based
runtimes, is rife with package-level build systems and tools. Most
ultimately center around the long-lived tool, _make_, in either its
System V or GNU realizations, with the GNU realization being most
common today.

Prior to the introduction of and near ubiquity of GNU make,
portability of System V _make_ across UNIX operating systems and with
GNU _make_ was fraught with nuance and incompatibilities,
consequently, meta-make systems emerged, expressing build semantics in
a system- and make-independent meta-make language with meta-processing
tools generating system-specific makefile output. These include
systems such as:

  * [Boost Jam](https://www.boost.org/doc/libs/1_31_0/tools/build/jam_src/index.html)
  * [CMake](https://cmake.org/)
  * [Freetype Jam](http://freetype.sourceforge.net/jam/)
  * [GN](https://gn.googlesource.com/gn/)
  * [GNU autotools](https://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html)
  * [imake](https://en.wikipedia.org/wiki/Imake)
  * [Perforce Jam](https://en.wikipedia.org/wiki/Perforce_Jam)
  * [qmake](https://en.wikipedia.org/wiki/Qmake)

There even exist some tools today that eliminate _make_ altogether
(although it's unclear why) recreating some of its functionality in
the process, such as Google's Blaze / Bazel or Ninja.

Looking across the explosion of breadth that is the software
development world today, spanning embedded systems to cloud services
and all of the languages and runtimes that cover them, there are even
more package-level systems supporting cloud computing, the Android,
the iOS, the macOS, and the Windows ecosystems.

## System- versus Package-level Build Systems

While the software development world is rife with _package-level_ build
systems--that is, build systems designed to create and, possibly
package, components for a larger platform ecosystem--there are very
few portable, reusable _system-level_ build systems designed to generate
entire installation images for hardware systems or platform ecosystems
and even fewer that are designed to do so in a way that is independent
of the target operating system for that hardware.

Historically, when it comes to C- and C++-based runtimes and systems,
the world was bifurcated in two: desktop and server systems versus
embedded systems.

### Desktop and Server Systems

In the desktop and server systems world, the vendors (e.g. Apple, HP,
IBM, Microsoft, Sun, Silicon Graphics) that ran those systems had in
house system-level build frameworks that produced OS release images
for those systems. Those vendors also had developer tools that could
produce additional applications or packages for those systems and
their platform ecosystems but could not produce the OS release itself.

### Embedded Systems

In contrast, the embedded systems world was historically a
heterogeneous patchwork of instruction set architectures (ISAs),
embedded operating systems (if at all), and vendor-unique toolchains
and integrated development environments (IDEs) to produce a system
image for those systems. Those toolchains and IDEs were often far from
open and were largely designed to lock a developer into that vendor's
ecosystem and ongoing seat license and maintenance revenue
streams. Engineers rarely questioned them and largely ran them
as-is. In fact, in many cases for such systems, the board or hardware
engineer was also the software engineer and could often be counted on
to understand as little as possible about software development.

### Recent Times

As Linux began to proliferate in the late 1990s and early 2000s,
distributions such as Redhat and Debian and their derivatives
flourished as complete, turnkey OS solutions. The derivatives began to
flourish because Redhat and Debian chose to not only publish the tools
used to create value-added packages for those distributions but also,
unlike the past proprietary UNIX vendors, the tools used to create
whole OS system images themselves.  In modern times, this has led to a
veritable explosion of Linux-based system distributions, as evidenced
by this timeline:

<p style="text-align:center">[https://upload.wikimedia.org/wikipedia/commons/1/1b/Linux_Distribution_Timeline.svg](https://upload.wikimedia.org/wikipedia/commons/1/1b/Linux_Distribution_Timeline.svg)</p>

most of them evolving from one of:

  * Debian
  * Redhat
  * Slackware

but many, in fact, evolving on their own, independent of one of these
three origins.

Further lending diversity to this Linux-based system distribution has
been the arrival of Linux-based systems that are not open Linux
platform distributions of their own but rather open platforms of their
own, but based on Linux. That is, Linux is the means to an end, not
the end itself. Examples of these include Android and Chrome OS, each
of which come with their own system-level build frameworks. Here, they
are geared much more like the UNIX vendors of yesteryear: focusing
developers on building value on top of the platform, not building the
platform itself.

Meanwhile, the non-Linux side of the embedded systems world has not
evolved much. Most systems still are tightly-coupled to a particular
toolchain vendor's environment and IDE. Though, many IDEs have
evolved from the origin of the open source Eclipse as their
foundation. However, the Linux revolution, coupled with the mobile
device and ARM ISA revolution, have guaranteed a highly-optimized,
open source, and free GCC or clang/LLVM toolchain for any ARM ISA
processor that can run on just about any development host system.

The challenge was and is, if you want to build a system image that is
not tied directly to a toolchain vendor's environment and IDE or if
you want to build a system image that is not just a clone of another
Linux distribution, typically with package management as the
concomitant software update and management mechanism, then there are
precious few open options available for building a product system
image.

# Requirements

The following sections attempt to enumerate the requirements suitable
for Nuovations Build.

## Summary

| Requirement |
| ----------- |
| The build system should work with tools found on most common engineering development systems without downloading and installing many extra tools beyond an instruction set architecture (ISA)-specific tool chain. |
| The core build system should be command-line based. |
| The build system should be independent of the version control system. |
| The build system should function both inside and outside of version control. |
| The build system should support building multiple disparate and independent products, concurrently, in the same tree without, by default, results or actions of one product impacting another. |
| The build system should support building multiple disparate but related configurations for a given product, concurrently, in the same tree without, by default, results or actions of one product configuration impacting another. |
| The build system should support building any product and configuration with multiple toolchains, concurrently, in the same tree without, by default, results or actions of one build impacting another. |
| The build system should support a directory / tree structure chosen by the product or project using the build system. |
| The build system should support multiple build files per subdirectory. |
| The build system should support multiple targets per build file. |
| The build system should not rely on blessed build files names for iteration. |
| The build system should not be dependent on and should be independent of the target instruction set architecture. |
| The build system should not be dependent on and should be independent of the target operating system, if any. |
| The build system should not be dependent on and should be independent of the target toolchain. |
| The build system should not be dependent on and should be independent of the target software packaging system, if any. |
| The build system should be able to check and, by default enforce, that the toolchain being invoked for a build product and configuration is that intended by the product owner. |
| The build system should lead to, by default, build files for archive libraries, shared libraries, program executables, or system images that are short, concise, and that contain minimal boilerplate. |
| The build system should be able to preprocess, compile, and/or assemble any C or C++ source and header file into an object file. |
| The build system should be able to archive object files into an archive library for any system. |
| The build system should be able to link object files into a shared library, program executable, or system image, depending on the capabilities of the target system. |
| The build system, by default, should have succinct, consistent, and well-formatted output. |
| There should be an option to enable, conditionally, verbose diagnostic output. |
| The build system should support building from any arbitrary subdirectory otherwise included in the build process. |
| The build system should support parallel or non-parallel builds. |
| The build system should be approachable and should support common or familiar targets for accomplishing common or familiar things such as "all", "help", "clean", "check", or "test". |
| The build system should be capable of integrating and driving other package-level build systems. |
<p style="text-align:center">**Table 1.** Summary of Frontline Controller software build system requirements.</p>

## Requirement

The build system should work with tools found on most common
engineering development systems without downloading and installing
many extra tools beyond an instruction set architecture (ISA)-specific
tool chain.

### Motivation and Rationale

This author has created a build system that has evolved over time to
encompass Sun Solaris, Linux, Mac OS X, and, at times, Microsoft
Windows with Cygwin or Mingw--generally UNIX-compatible or UNIX-like
systems development build hosts. In all cases, these systems have a
UNIX / POSIX runtime, shell and shell tools, and GNU
_make_. Consequently, most of the core build system is structured
around that limited set of dependencies.

## Requirement

The core build system should be command-line based.

### Motivation and Rationale

It is posited that it is easier to build a UI/UX or IDE around or
drive a CLI-based build system than it is to build a CLI-based
automation framework around a UI/UX or IDE.

While IDEs are a powerful, and at their best often productive,
solution for the integrated write, compile, test, and debug loop that
is the life of software developers, they are rarely amenable to
integration into automation frameworks often used and required by
software release and integration / software quality assurance
engineering teams.

## Requirement

The build system should be independent of the version control system.

### Motivation and Rationale

Different organizations use different version control systems and
version control systems have variability over time about what is in
vogue.

Over the three generations of life of build systems created by this
author, they have seen the following version control systems:

  * RCS
  * CVS
  * BitKeeper
  * Clearcase
  * Perforce
  * Subversion
  * git

The only constant in software is truly change.

Keeping the build system independent of the version control system
allows the build system adopter to choose the version control system
best suited for his or her organization and project.

Moreover, keeping the build system separate from version control is
generally a good separation of concern and function. Build systems
tend to be about transforming input sources into intermediate and
final build artifacts. Version control systems tend to be about
controlling the version of input sources used for transformation of
those input sources into artifacts.

## Requirement

The build system should function both inside and outside of version control.

### Motivation and Rationale

Often the build needs to be archived or snapshot to be shared with
vendors or partners who do not and cannot participate in the project's
version control system. The projects based on the build system should
function equally well with or without the version control system.

## Requirement

The build system should support building multiple disparate and
independent products, concurrently, in the same tree without, by
default, results or actions of one product impacting another.

### Motivation and Rationale

How a site or vendor structures a project or product with the build
system is ultimately up to him or her. If there is a large degree of
synergy or sharing across project products, then it may be
advantageous to have multiple such products in the same project. All
the more so if they tend to follow the same release cadence.

Consequently, it should be possible from one snapshot of sources to
build one product in such a project and then the other, in any
arbitrary order without one impacting the other. This allows the
developer to work with confidence on the products in parallel with the
knowledge that one does not impact the other with the convenience of
comparing the artifacts from one, side-by-side with the other.

However, if a developer chooses to instantiate two projects with the
build system, one for each of two products, then the developer should
be able to do that as well.

## Requirement

The build system should support building multiple disparate but
related configurations for a given product, concurrently, in the same
tree without, by default, results or actions of one product
configuration impacting another.

### Motivation and Rationale

Often, for a given project product, there will exist different
configurations of a build that will enable different features,
compiler optimizations, debug output, or debug tools or APIs. In the
projects of the write, compile, test, and debug loop, particularly
when isolating problems, it may be advantageous to compare a "release"
build against a "debug" build from the same tree and compare both the
execution behavior on target as well as the side-by-side artifacts on
the development host.

## Requirement

The build system should support building any product and configuration
with multiple toolchains, concurrently, in the same tree without, by
default, results or actions of one build impacting another.

### Motivation and Rationale

For better or worse, toolchains have bugs and, unfortunately, those
bugs often lead to insidious and difficult to debug problems in
products. Likewise, for the better, toolchains also tend to get better
over time, either compiling and linking existing input faster or
producing build artifacts that are smaller.

As a result, project product teams tend to evolve the toolchain in use
for a project over time, often concurrently using one or more during
investigation of a potential toolchain bug or while investigating the
upgrade to a new toolchain version.

As with product and configuration, it should be possible for a
developer to evaluate one or more toolchains and the artifacts they
produce side-by-side across toolchain versions for any product and
configuration.

## Requirement

The build system should support a directory / tree structure chosen by
the product or project using the build system.

### Motivation and Rationale

The grouping and organization of input sources into packages, modules,
and submodules is a decision that should be dictated by the product
project owner not by the build system designer. Only the product
project owner knows what is appropriate for his or her project.

## Requirement

The build system should support multiple build files per subdirectory.

### Motivation and Rationale

The choice of whether to create a single artifact in a subdirectory or
multiple artifacts in a subdirectory is a decision only the product
project owner can make based on what is appropriate for his or her
project. Creating a program executable and an archive library it
depends on in the same directory may be appropriate for one project or
one module within a project but not another.

The build system cannot and should not possibly make a policy decision
in this regard.

## Requirement

The build system should support multiple targets per build file.

### Motivation and Rationale

The choice of whether to create a single artifact in a build file or
multiple artifacts in a build file is a decision only the product
project owner can make based on what is appropriate for his or her
project.

With the ability to support multiple build files per subdirectory and
multiple targets per build file, the product project owner has the
ultimate flexibility to decide on one target per build file and one
build file per subdirectory or many targets per build file and many
build files per subdirectory.

## Requirement

The build system should not rely on blessed build files names for iteration.

### Motivation and Rationale

While make does recognize a default build file as "Makefile", when
supporting multiple build files per subdirectory, the ability to
leverage this convenient default falls apart. Moreover, "Makefile" may
not be the most intuitive or obvious build file name for a particular
project context.

By allowing project makefiles to specify what other makefiles they
depend upon and want to invoke, the project product maintainer is in
control of how to structure and name his or her project and the
makefiles within it.

## Requirement

The build system should not be dependent on and should be independent
of the target instruction set architecture.

### Motivation and Rationale

While in today's world the ARM instruction set architecture is nearly
ubiquitous for embedded systems, it is not the only ISA software
engineering teams must consider. Particularly when just considering an
on-target system image versus an on-development build host simulator
of the same, instruction sets are liable to be ARM for the former and
x86_64 for the latter.

Simulators aside, product managers and supply chain managers will
almost always make the silicon choice that addresses not only the
software engineering team's input and established code base but also
project cost targets and other considerations. While it might be
convenient for software engineering to have an ARM-only software base,
the reality of multiple ISAs can rarely be ignored.

## Requirement

The build system should not be dependent on and should be independent
of the target operating system, if any.

### Motivation and Rationale

While a one product or one product line company might have the luxury
or limitation of having a single OS strategy, multi-product or
multi-product line companies are likely to have a span of products
with different operating systems for each. Even the single product
company may have one OS for on-target runtime and another for
on-development host simulators.

Over the three generations of life of build systems created by this
author, they have seen support for building against the following
target operating systems:

  * FreeRTOS
  * iOS
  * Irix
  * Linux
  * macOS
  * RTXC
  * Solaris
  * VxWorks

## Requirement

The build system should not be dependent on and should be independent
of the target toolchain.

### Motivation and Rationale

This mostly follows from the independence of the target instruction
set architecture; however, even within a given ISA, it is often
desirable to support both GCC and clang/LLVM or different versions of
each.

Also, different toolchains have different mnemonics for different
toolchain options and semantics for assembling vs. compiling
vs. preprocessing, so abstracting those differences away makes it
easier for a given project to move seamlessly across toolchains.

## Requirement

The build system should not be dependent on and should be independent
of the target software packaging system, if any.

### Motivation and Rationale

How a target software is bundled into a system image and ultimately
delivered and software updated is a very product-specific decision. A
package-based system may be very appropriate for one product and its
use cases whereas a monolithic system image may be appropriate for
another. In fact, for many package-based systems, the package system
(e.g. Redhat Package Manager) may actually effect a build system in
its own right.

In addition, software packaging often gets into tooling and issues
such as code signing, the scope of which can be driven by the build
system but the infrastructure for which belongs on top of the build
system rather than in its core infrastructure.

## Requirement

The build system should be able to check and, by default enforce, that
the toolchain being invoked for a build product and configuration is
that intended by the product owner.

### Motivation and Rationale

Relying on the user's executable search path alone, it is far too easy
to pick-up and run the incorrect toolchain relative to what the
product project maintainer intended, particularly when multiple
toolchains, including multiple versions of the same toolchain, exist
on the development build system.

Nuovation has spent too many hours debugging issues where the root
cause was "Oh, you're running the old version of the toolchain that we
deprecated a month ago in lieu of the new version from the vendor that
fixed a compiler bug.".

Having this check supported by the build system infrastructure ensures
that product projects are easily built with the tools that the project
maintainer intended and only those tools and that deviations from that
are the responsibility of the user making explicitly, rather than
inadvertently, making the deviation.

## Requirement

The build system should lead to, by default, build files for archive
libraries, shared libraries, program executables, or system images
that are short, concise, and that contain minimal boilerplate.

### Motivation and Rationale

This follows from the old edict to make the common case fast and
easy. As disappointing as it might be, most software engineers know
precious little about and are interested in learning precious little
about how to author project build files. They strictly want to achieve
the following: "I have some new header or source files and I want to
make them into an archive, library, program, or image and get them to
be included by the build.".

The path and semantics for them to successfully achieve that goal
should be as short, simple, and succinct as possible.

Accomplishing more complex tasks may be more difficult, but making and
adding new archives, libraries, programs, or images to the project
should be easy.

## Requirement

The build system should be able to preprocess, compile, and/or
assemble any C, C++, Objective C, or Objective C++ source and header
file into an object file.

### Motivation and Rationale

For most embedded product projects in particular, this is the "meat
and potatoes" of the project: transforming the project's collection of
input source files into another collection of final, and in this
particular case intermediate, archive, library, program, and image
artifacts.

Of course, bugs and issues arise in the steps between transforming a
source file into an object file, so having easy to use and built-in
rules for intermediate transforms into preprocessed or assembler
output is also important so that the developers can easily answer:
"What the heck is actually going on behind the scenes?" with the
preprocessor, assembler, or compiler.

## Requirement

The build system should be able to archive object files into an
archive library for any system.

### Motivation and Rationale

Whether it is creating shared libraries, executable programs, or
system images, archive libraries of related objects are the
compositional workhorse artifact of most C- or C++-based builds.

Creating archive libraries should be easy.

## Requirement

The build system should be able to link object files into a shared
library, program executable, or system image, depending on the
capabilities of the target system.

### Motivation and Rationale

While archive libraries are the compositional workhorse artifacts
supported by any architecture or target system, execution context on
target systems is provided by linked program executables (and their
shared libraries) or system images.

Creating shared libraries, program executables, and system images
should be easy.

## Requirement

The build system, by default, should have succinct, consistent, and
well-formatted output. There should be an option to enable,
conditionally, verbose diagnostic output.

### Motivation and Rationale

Just like in a car, when a build system is running normally, it should
be clear of extraneous outputs and signals, succinctly and clearly
indicating progress. Failures in the form of warnings or errors should
standout abundantly and clearly from the nominal, default output.

When failures do occur or when the developer desires to see very
fine-grained detail about what exactly is happening in the build,
including specific command invocations, then there should be a simple
and easy way to enable that level of verbosity, dynamically.

## Requirement

The build system should support building from any arbitrary
subdirectory otherwise included in the build process.

### Motivation and Rationale

While top-level builds should always be both fast and incremental, the
mode in which most developers work is focused on a particular
subsystem that circumscribes their work for the minute, hour, or
day. Being able to build within the subsystem he or she is currently
working on ensures the tightest possible write, compile, test, and
debug loop possible.

## Requirement

The build system should support parallel or non-parallel builds.

### Motivation and Rationale

In engineering, time is money. Slow builds mean that both human and
compute resources are tied up when they could and should be doing
something else. Supporting parallel builds means that compute
resources are maximized and, by extension, human resources are
maximized.

However, parallel builds can often be difficult to debug and often
mandate serializing to triage. Therefore, it should be possible to
support both serial and parallel builds, with the latter bound by the
resources of the development build host.

## Requirement

The build system should be approachable and should support common or
familiar targets for accomplishing common or familiar things such as
"all", "help", "clean", "check", or "test".

### Motivation and Rationale

At the end of the day, effective infrastructure allows people to get
their jobs done. And, primarily, the job of the build system is to
transform input sources into final artifacts that will ultimately
drive a product to meet its behavioral and functional requirements for
its customers.

Consequently, the steps required for a developer to generate and
validate those artifacts should be as familiar and as easy as
possible.

While there is a nearly infinite amount of variation in the world of
package-level build systems and build files for them, familiarity with
and support for a few common targets is nearly universal.

  all
  : Generate all configured build artifacts for the project.

  check | test
  : Generate all configured build artifacts and run all unit and functional tests for this project.

  clean
  : Remove all configured build artifacts for this project.

## Requirement

The build system should be capable of integrating and driving other
package-level build systems.

### Motivation and Rationale

In today's world, even the smallest of embedded engineering projects
leverages third-party source code, either in the form of
vendor-supplied code or in the form of open source code.

For large projects, particularly those based on Linux, a vast majority
of the code may be third-party and open source code.

Consequently, it must be not only possible but easy to integrate the
arbitrary package-level build systems of that third-party code,
including but not limited to:

  * Bespoke Makefiles
  * Boost Jam
  * CMake
  * Freetype Jam
  * GNU autotools
  * imake
  * Perforce Jam
  * qmake
