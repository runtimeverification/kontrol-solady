// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { TestBase } from "forge-std/Base.sol";

interface KEVMCheatsBase {
    // Makes the storage of the given address completely symbolic.
    function symbolicStorage(address) external;
    // Set the current <gas> cell
    function infiniteGas() external;
    // Returns a symbolic unsigned integer
    function freshUInt(uint8) external pure returns (uint256);
    // Returns a symbolic boolean value
    function freshBool() external pure returns (bool);
}

contract KevmUtil {
    KEVMCheatsBase internal constant kevm = KEVMCheatsBase(address(uint160(uint256(keccak256("hevm cheat code")))));

    function freshBytes32() internal pure returns (bytes32) {
        return bytes32(kevm.freshUInt(32));
    }

    function freshUInt256() internal pure returns (uint256) {
        return kevm.freshUInt(32);
    }

    function freshBool() internal pure returns (bool) {
        return kevm.freshBool();
    }

    function freshAddress() internal pure returns (address) {
        return address(uint160(kevm.freshUInt(20)));
    }
}
