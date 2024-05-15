#!/bin/bash

set -euxo pipefail

kontrol_kompile() {
    kontrol build                     \
            --verbose                 \
            --require ${lemmas}       \
            --module-import ${module} \
            ${rekompile}              \
            ${regen}                  \
            ${llvm_library}
}

kontrol_prove() {
    kontrol prove                              \
            --max-depth ${max_depth}           \
            --max-iterations ${max_iterations} \
            --smt-timeout ${smt_timeout}       \
            --workers ${workers}               \
            ${reinit}                          \
            ${bug_report}                      \
            ${break_on_calls}                  \
            ${auto_abstract}                   \
            ${tests}                           \
}

lemmas=test/solady-lemmas-mod.k
base_module=SOLADY-LEMMAS
module=FixedPointMathLibVerification:${base_module}

max_depth=10000
max_iterations=10000
smt_timeout=10000000


# Number of processes run by the prover in parallel
# Should be at most (M - 8) / 8 in a machine with M GB of RAM
workers=2

regen=--regen
regen=

rekompile=--rekompile
rekompile=

# Progress is saved automatically so an unfinished proof can be resumed from where it left off
# Turn on to restart proof from the beginning instead of resuming
reinit=--reinit
reinit=

break_on_calls=--no-break-on-calls
# break_on_calls=

auto_abstract=--auto-abstract-gas
auto_abstract=

bug_report=--bug-report
bug_report=

# For running the booster
llvm_library=--with-llvm-library
llvm_library=

# For running the booster
use_booster=--use-booster
use_booster=

# List of tests to symbolically execute
tests=""
tests+="--match-test FixedPointMathLibVerification.testMulWad(uint256,uint256) "
tests+="--match-test FixedPointMathLibVerification.testMulWadUp "

# Comment these lines as needed
pkill kore-rpc || true
kontrol_kompile
kontrol_prove
