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
            mulWad(x, y);
        }

    }

    function testMulWadUp(uint256 x, uint256 y) public {

        if(y == 0 || x <= (type(uint256).max)/y) {
            uint256 zSpec = ((x * y)/WAD)*WAD < x * y ? (x * y)/WAD + 1 : (x * y)/WAD;
            uint256 zImpl = FixedPointMathLib.mulWadUp(x, y);

            assert(zImpl == zSpec);
        } else {
            vm.expectRevert(FixedPointMathLib.MulWadFailed.selector); // FixedPointMathLib.MulWadFailed.selector
            mulWadUp(x, y);
        }
    }
}
