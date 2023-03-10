# Changes, Release Notes, and What's New

## Nuovations Build (Make)

#### 0.9.4d (2023-02-27)

    * Added support for generating monotonically-increasing, per-target
      build generation numbers. This addressed an issue in which targets
      would always be out of date due to the absence of this support.

#### 0.9.3d (2023-02-22)

    * Addressed an issue in setup.sh where basename issues an error
      under certain shells that it was provided with no argument.

#### 0.9.2d (2023-02-21)

    * Added implicit rules for transforming output from auto-generated
      source files in the build directory.

#### 0.9.1d (2023-02-21)

    * Ensure that the top-level makefile, 'Makefile', is present as an
      additional test for establishing BuildRoot when setting up the shell
      environment.

    * When setting up the shell environment, refine the method by which the
      first directory path iterator is derived such that it is compatible with
      bash, dash, ksh, sh, and zsh.

    * Addressed three documentation typos in GETTING_STARTED.md.

#### 0.9.0d (2023-02-20)

    * First public, open-source release.
