#!/bin/bash

set -euxo pipefail

forge_build() {
    forge build
}

foundry_kompile() {
    kevm foundry-kompile --verbose \
        --require ${lemmas}        \
        --module-import ${module}  \
        ${rekompile}               \
        ${regen}                   \
        ${llvm_library}
}

foundry_prove() {
    kevm foundry-prove                     \
        --max-depth ${max_depth}           \
        --max-iterations ${max_iterations} \
        --bmc-depth ${bmc_depth}           \
        --workers ${workers}               \
        --verbose                          \
        ${reinit}                          \
        ${debug}                           \
        ${simplify_init}                   \
        ${implication_every_block}         \
        ${break_every_step}                \
        ${break_on_calls}                  \
        ${auto_abstract}                   \
        ${bug_report}                      \
        ${tests}                           \
        ${use_booster}                     \
#        --kore-rpc-command "${kore_rpc_command}"
}

foundry_claim() {
    kevm prove ${lemmas}                      \
        --claim ${base_module}-SPEC.${claim}  \
        --definition out/kompiled            \
        --spec-module ${base_module}-SPEC
}

lemmas=test/solady-lemmas.k
base_module=SOLADY-LEMMAS
module=FixedPointMathLibVerification:${base_module}

claim=first-roadblock

max_depth=10000
max_iterations=10000

bmc_depth=3

# Number of processes run by the prover in parallel
# Should be at most (M - 8) / 8 in a machine with M GB of RAM
workers=16

# Switch the options below to turn them on or off
# TODO: Describe this thoroughly
regen=--regen # Regenerates all of the K definition files
regen=

rekompile=--rekompile # Rekompiles
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

auto_abstract=--auto-abstract
auto_abstract=
auto_abstract=--auto-abstract-gas

bug_report=--bug-report
bug_report=

# For running the booster
llvm_library=
llvm_library=--with-llvm-library

# For running the booster
use_booster=
use_booster=--use-booster

kore_rpc_command=
kore_rpc_command=kore-rpc-booster\ --simplify-after-exec\ --llvm-backend-library\ out/kompiled/llvm-library/interpreter.so

# List of tests to symbolically execute

tests=""
tests+="--test FixedPointMathLibVerification.testMulWadInRange "
#tests+="--test FixedPointMathLibVerification.testMulWadUpInRange "

# Comment these lines as needed
pkill kore-rpc || true
forge_build
foundry_kompile
foundry_prove
#foundry_claim
