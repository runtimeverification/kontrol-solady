// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "solady/src/utils/FixedPointMathLib.sol";

import "./KevmUtil.sol";

contract FixedPointMathLibVerification is Test, KevmUtil {

    // Constants
    uint256 constant WAD = 1e18;

    function testMulWad(uint256 x, uint256 y) public {

        if(y == 0 || x <= type(uint256).max / y) {
            uint256 zSpec = (x * y) / WAD;
            uint256 zImpl = FixedPointMathLib.mulWad(x, y);

            assertEq(zImpl, zSpec);
        } else {
            vm.expectRevert(); // FixedPointMathLib.MulWadFailed.selector
            FixedPointMathLib.mulWad(x, y);
        }

    }

    function testMulWadUp(uint256 x, uint256 y) public {

        if(y == 0 || x <= (type(uint256).max)/y) {
            uint256 zSpec = ((x * y)/WAD)*WAD < x * y ? (x * y)/WAD + 1 : (x * y)/WAD;
            uint256 zImpl = FixedPointMathLib.mulWadUp(x, y);

            assertEq(zImpl, zSpec);
        } else {
            vm.expectRevert(); // FixedPointMathLib.MulWadFailed.selector
            FixedPointMathLib.mulWadUp(x, y);
        }
    }

    function testLog2(uint256 x) public {
        uint256 r = FixedPointMathLib.log2(x);

        if (x > 0){
            assertLe(2**r, x);
            if (r < 255)
                assertLt(x, 2**(r+1));
            else
                assertEq(r, 255);
        } else
            assertEq(r,0);
    }

    function log2(uint256 x) internal pure returns (uint256 r) {
        /// @solidity memory-safe-assembly
        assembly {
            r := shl(7, lt(0xffffffffffffffffffffffffffffffff, x))
            //r := or(r, shl(6, lt(0xffffffffffffffff, shr(r, x))))
            //r := or(r, shl(5, lt(0xffffffff, shr(r, x))))
            //r := or(r, shl(4, lt(0xffff, shr(r, x))))
            //r := or(r, shl(3, lt(0xff, shr(r, x))))
            //r := or(r, shl(2, lt(0xf, shr(r, x))))
            //r := or(r, byte(shr(r, x), hex"00000101020202020303030303030303"))
        }
    }
    function testMyLog2(uint256 x) public {
        uint256 r = log2(x);
        if(x > 0)
            assertLe(2**r, x);
        else
            assertEq(r,0);
    }
}
