# o3de-builder

A repository containing helpers for building O3DE on Linux.
It only works on LTS versions of Ubuntu, but in theory its artifacts could be used elsewhere.

## How to use

* This repository uses Just, a make-inspired script runner, so you need that.
* Run `just` in the repo for a hands-off installation. This will use sudo to install these packages.
  * ```
    build-essential clang-6.0 uuid-dev libz-dev libncurses5-dev libcurl4-openssl-dev
    mesa-common-dev libglu1-mesa-dev libjpeg-dev libjbig-dev libsdl2-dev
    libxcb-xinerama0 libxcb-xinput0 libfontconfig1-dev libopus-dev libwebp-dev
	* To only perform certain actions, you can use `just <actions>`.
  	* `just clone configure build` will just update the repo, configure, and build, without any other steps.
  	* `just deps dirs clone python` will set everything up to build the engine, but not actually build it.