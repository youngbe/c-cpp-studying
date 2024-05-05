#!/bin/bash

args=(
# Options for Code Generation Conventions
-fstack-reuse=all -fjump-tables -fbit-tests -fno-strict-volatile-bitfields
-fdelete-dead-exceptions

# Program Instrumentation Options
-fno-sanitize=all
-fcf-protection=none
-fno-harden-compares
-fno-harden-conditional-branches
-fno-harden-control-flow-redundancy
-fno-hardened
-fno-stack-protector
-fno-stack-check
-fno-stack-clash-protection
-fno-stack-limit
-fno-split-stack
-fstrub=disable
-fvtable-verify=none
# -fno-instrument-functions

# default optimize
-fstdarg-opt
-ftrivial-auto-var-init=uninitialized
-fno-conserve-stack
# -fdelete-null-pointer-checks

# O3
-fomit-frame-pointer -fstrict-aliasing -foptimize-sibling-calls -ftree-loop-vectorize -ftree-slp-vectorize

# Ofast:
# -ffast-math
-fallow-store-data-races
# 仅对共享库有效
-fno-semantic-interposition

# Ofast之外：
-fipa-pta -fdevirtualize-at-ltrans -fmerge-all-constants -funroll-loops -funroll-all-loops

# math相关
-fno-float-store
-ffp-contract=fast
-ffast-math
# fast-math enable:
-fno-math-errno -funsafe-math-optimizations -ffinite-math-only -fno-rounding-math -fno-signaling-nans -fcx-limited-range -fexcess-precision=fast
# unsafe-math-optimizations enables:
-fno-signed-zeros -fno-trapping-math -fassociative-math -freciprocal-math
# -funsafe-math-optimizations 链接器也需要这个选项，会链接到crtfastmath.o，设置mxcsr

# other
-std=gnu++23 -D_GNU_SOURCE -g0 -Ofast -Wall -Wextra -Wshadow
# -Wstrict-prototypes // C only
)

g++-14 "${args[@]}" "$@"
