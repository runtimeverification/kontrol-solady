#!/bin/bash

set -euxo pipefail

forge_build() {
    forge build
}

kontrol_kompile() {
    kontrol build                     \
            --verbose                 \
            --require ${lemmas}       \
            --module-import ${module} \
            ${rekompile}
}

kontrol_prove() {
    kontrol prove                              \
            --max-depth ${max_depth}           \
            --max-iterations ${max_iterations} \
            --smt-timeout ${smt_timeout}       \
            --workers ${workers}               \
            --verbose                          \
            ${reinit}                          \
            ${debug}                           \
            ${bug_report}                      \
            ${simplify_init}                   \
            ${implication_every_block}         \
            ${break_every_step}                \
            ${break_on_calls}                  \
            ${tests}                           \
            ${use_booster}
}

kontrol_claim() {
    kevm prove                               \
        ${lemmas}                            \
        --claim ${base_module}-SPEC.${claim} \
        --definition out/kompiled            \
        --spec-module ${base_module}-SPEC    \
        --smt-timeout ${smt_timeout}
}

lemmas=test/solady-lemmas.k
base_module=SOLADY-LEMMAS
module=FixedPointMathLibVerification:${base_module}

max_depth=10000
max_iterations=10000
smt_timeout=100000

# Number of processes run by the prover in parallel
# Should be at most (M - 8) / 8 in a machine with M GB of RAM
workers=12

# Switch the options below to turn them on or off
rekompile=--rekompile
#rekompile=

# Progress is saved automatically so an unfinished proof can be resumed from where it left off
# Turn on to restart proof from the beginning instead of resuming
reinit=--reinit
#reinit=

debug=--debug
debug=

simplify_init=--no-simplify-init
simplify_init=

implication_every_block=--no-implication-every-block
implication_every_block=

break_every_step=--break-every-step
break_every_step=

break_on_calls=
break_on_calls=--no-break-on-calls

bug_report=--bug-report
bug_report=

# For running the booster
use_booster=--use-booster
#use_booster=

# List of tests to symbolically execute

tests=""
tests+="--test FixedPointMathLibVerification.testMulWad(uint256,uint256) "
tests+="--test FixedPointMathLibVerification.testMulWadUp "

# Name of the claim to execute
claim=mulWadUp-first-roadblock

# Comment these lines as needed
pkill kore-rpc || true
forge_build
kontrol_kompile
kontrol_prove
#kontrol_claim
