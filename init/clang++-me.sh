#!/bin/bash

args=(
# Options for Code Generation Conventions
# -fstack-reuse=all
# -fno-unwind-tables
# -fno-asynchronous-unwind-tables
# -fno-exceptions
-fjump-tables
# -fbit-tests
# -fno-strict-volatile-bitfields
# -fdelete-dead-exceptions



# Program Instrumentation Options
-fno-sanitize=all
-fcf-protection=none
# -fno-harden-compares
# -fno-harden-conditional-branches
# -fno-harden-control-flow-redundancy
# -fno-hardened
-fno-stack-protector
-fno-stack-check
-fno-stack-clash-protection
# -fno-stack-limit
-fno-split-stack
# -fstrub=disable
# -fvtable-verify=none
# -fno-instrument-functions



# default optimize
# -fstdarg-opt
-ftrivial-auto-var-init=uninitialized
# -fno-conserve-stack



# O3
-fomit-frame-pointer
-fstrict-aliasing
-foptimize-sibling-calls
# -ftree-loop-vectorize
-fvectorize
# -ftree-slp-vectorize
-fslp-vectorize
# -fdelete-null-pointer-checks



# Ofast:
# -ffast-math: 在后面打开
# -fallow-store-data-races
# 仅对共享库有效
-fno-semantic-interposition



# Ofast之外：
# -fipa-pta
# -fdevirtualize-at-ltrans
-fmerge-all-constants
-funroll-loops
# -funroll-all-loops



# math相关
# -fno-float-store
-ffast-math
# fast-math enable:
-fno-math-errno
# -funsafe-math-optimizations: 链接器也需要这个选项，会链接到crtfastmath.o，设置mxcsr
# -mno-daz-ftz :此选项可以防止链接crtfastmath.o
-funsafe-math-optimizations
# -ffinite-math-only == -fno-honor-infinities + -fno-honor-nans
-ffinite-math-only
-fno-honor-infinities
-fno-honor-nans
-fno-rounding-math
# -fno-signaling-nans
# -fcx-limited-range == -fcomplex-arithmetic=basic
# -fcomplex-arithmetic=basic
-fexcess-precision=fast
# unsafe-math-optimizations enables:
-fapprox-func
-fno-signed-zeros
-fno-trapping-math
-fassociative-math
-freciprocal-math
-ffp-contract=fast



# other
-std=gnu++23 -D_GNU_SOURCE -g0 -Ofast -Wall -Wextra -Wshadow
# -Wstrict-prototypes // C only
)

clang++-18 -fno-addrsig -fuse-ld=lld-18 -Wno-unused-command-line-argument "${args[@]}" "$@"
