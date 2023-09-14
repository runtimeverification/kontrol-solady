// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "solady/src/utils/FixedPointMathLib.sol";

import "./KevmUtil.sol";

contract FixedPointMathLibVerification is Test, KevmUtil {

    // Constants
    uint256 constant WAD = 1e18;

    function setUp() public {
        // Make KEVM abstract gas computations
        kevm.infiniteGas();
    }

    function testMulWadInRange(uint256 x, uint256 y) public {
        // Assume x * y won't overflow
        vm.assume(y == 0 || x <= type(uint256).max / y);

        uint256 zSpec = (x * y) / WAD;
        uint256 zImpl = FixedPointMathLib.mulWad(x, y);

        assertEq(zImpl, zSpec);
    }

    function testMulWadUpInRange(uint256 x, uint256 y) public {
        // Assume x * y + WAD/2 won't overflow
        vm.assume(y == 0 || x <= (type(uint256).max)/y);

        uint256 zSpec = ((x * y)/WAD)*WAD < x * y ? (x * y)/WAD + 1 : (x * y)/WAD;
        uint256 zImpl = FixedPointMathLib.mulWadUp(x, y);

        assertEq(zImpl, zSpec);
    }
}
