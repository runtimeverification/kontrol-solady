# Solady Formal Verification with Kontrol

This repo showcases how to perform formal verification of mathematical libraries using the [Kontrol](https://docs.runtimeverification.com/kontrol/overview/readme) ([KEVM](https://github.com/runtimeverification/evm-semantics) + [Foundry](https://github.com/foundry-rs/foundry/)) framework. In particular, we formally verify some of the functions present in the [Solady](https://github.com/vectorized/solady) library.

This is a work in progress, more functions are likely to be verified in the future.

## Verification Summary

We employ two different types of specification for function verification: function equivalence and property satisfaction. Function equivalence means verifying that a Solady function `f_solady` is equivalent to an external function (e.g., Solmate's equivalent) `f_spec`. Property satisfaction means verifying that the function `f_solady` satisfies a property `P`, which should describe the desired behaviour of `f_solady`.

### Verified functions

| Name       | Location                                                                                                                 | Equivalence | Property |
|------------|--------------------------------------------------------------------------------------------------------------------------|-------------|----------|
| `wadMul`   | [solady/src/utils/FixedPointMathLib.sol](https://github.com/Vectorized/solady/blob/main/src/utils/FixedPointMathLib.sol) | No          | Yes      |
| `wadMulUp` | [solady/src/utils/FixedPointMathLib.sol](https://github.com/Vectorized/solady/blob/main/src/utils/FixedPointMathLib.sol) | No          | Yes      |
| `log2    ` | [solady/src/utils/FixedPointMathLib.sol](https://github.com/Vectorized/solady/blob/main/src/utils/FixedPointMathLib.sol) | No          | Yes      |

## Repository Structure

General description of the repo, plus the location of the tests for the verified functions

## Verification Reproduction

Instructions on how to reproduce the verification work.

The recommended way of executing the verification script is to log the output trace in a file (called `log.out` here)

```bash
time bash test/run-kevm.sh 2>&1 | tee log.out
```
