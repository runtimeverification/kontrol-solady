// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "solady/src/utils/FixedPointMathLib.sol";
import "kontrol-cheatcodes/KontrolCheats.sol";

contract FixedPointMathLibVerification is Test, KontrolCheats {

    // Constants
    uint256 constant WAD = 1e18;

        // Public wrapper for mulWad since Kontrol doesn't support vm.expectRevert
    // for internal calls, and FixedPointMathLib.mulWad is internal
    function mulWad(uint x, uint y) public pure returns (uint256) {
        return FixedPointMathLib.mulWad(x, y);
    }

    // Public wrapper for mulWadUp since Kontrol doesn't support vm.expectRevert
    // for internal calls, and FixedPointMathLib.mulWadUp is internal
    function mulWadUp(uint x, uint y) public pure returns (uint256) {
        return FixedPointMathLib.mulWadUp(x, y);
    }

    function testMulWad(uint256 x, uint256 y) public {

        if(y == 0 || x <= type(uint256).max / y) {
            uint256 zSpec = (x * y) / WAD;
            uint256 zImpl = FixedPointMathLib.mulWad(x, y);

            assert(zImpl == zSpec);
        } else {
            vm.expectRevert(FixedPointMathLib.MulWadFailed.selector); // FixedPointMathLib.MulWadFailed.selector
            this.mulWad(x, y);
        }

    }

    function testMulWadUp(uint256 x, uint256 y) public {

        if(y == 0 || x <= (type(uint256).max)/y) {
            uint256 zSpec = ((x * y)/WAD)*WAD < x * y ? (x * y)/WAD + 1 : (x * y)/WAD;
            uint256 zImpl = FixedPointMathLib.mulWadUp(x, y);

            assert(zImpl == zSpec);
        } else {
            vm.expectRevert(FixedPointMathLib.MulWadFailed.selector); // FixedPointMathLib.MulWadFailed.selector
            this.mulWadUp(x, y);
        }
    }

    //function log2(uint256 x) internal pure returns (uint256 r) {
    //    /// @solidity memory-safe-assembly
    //    assembly {
    //        r := shl(7, lt(0xffffffffffffffffffffffffffffffff, x))
    //        r := or(r, shl(6, lt(0xffffffffffffffff, shr(r, x))))
    //        r := or(r, shl(5, lt(0xffffffff, shr(r, x))))
    //        r := or(r, shl(4, lt(0xffff, shr(r, x))))
    //        r := or(r, shl(3, lt(0xff, shr(r, x))))
    //        r := or(r, shl(2, lt(0xf, shr(r, x))))
    //        r := or(r, byte(shr(r, x), hex"00000101020202020303030303030303"))
    //    }
    //}

    //function testMyLog2(uint256 x) public {
    //    uint256 r = log2(x);
    //    if(x > 0)
    //        assertLe(2**r, x);
    //    else
    //        assertEq(r,0);
    //}

    function testLog2(uint256 x) public {

        unchecked {
          uint256 y = x; uint256 z = 0;
          if (2 ** 128 - 1 < y) { y = y >> 128; } else { }
          if (2 **  64 - 1 < y) { y = y >>  64; } else { }
          if (2 **  32 - 1 < y) { y = y >>  32; } else { }
          if (2 **  16 - 1 < y) { y = y >>  16; } else { }
          if (2 **   8 - 1 < y) { y = y >>   8; } else { }
          if (2 **   4 - 1 < y) { y = y >>   4; } else { }

          if (2 ** 3 - 1 < y) z = 4; else
          if (2 ** 2 - 1 < y) z = 3; else
          if (2 ** 1 - 1 < y) z = 2; else
          if (2 ** 0 - 1 < y) z = 1;
        }

        uint256 r = FixedPointMathLib.log2(x);

        if(x > 0){
            assertLe(2**r, x);
            if (r < 255) {
              assertLt(x, 2**(r+1));
            } else {
              assertEq(r, 255);
            }
        }
        else
            assertEq(r,0);
    }
}
