// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {SafeTransferLib} from "solady/utils/SafeTransferLib.sol";
import {Ownable} from "solady/auth/Ownable.sol";
import {AdvisorVestingWallet} from "src/AdvisorVestingWallet.sol";

contract AdvisorVestingWalletTest is Test {
    using SafeTransferLib for address;

    // December 1, 2023, 12:00 PM EST.
    uint64 public constant _VESTING_START = 1701450000;

    AdvisorVestingWallet public immutable vesting;
    address public immutable projectOwner;
    address public immutable token;
    address public immutable beneficiary = address(this);

    event ERC20Released(address indexed token, uint256 amount);

    constructor() {
        vesting = new AdvisorVestingWallet(beneficiary, _VESTING_START);
        projectOwner = vesting.owner();
        token = vesting.TOKEN();
    }

    function _getVestedTimestamp(
        uint256 vestedPercent
    ) private view returns (uint256) {
        uint256 vestedPercentDenominator = 100;

        // Set the timestamp anywhere from the vesting start to the end.
        return
            uint256(vesting.start()) +
            ((uint256(vesting.duration()) * vestedPercent) /
                vestedPercentDenominator);
    }

    function _getWithdrawVestingAmounts()
        private
        view
        returns (uint256 finalReleasableAmount, uint256 withdrawAmount)
    {
        finalReleasableAmount = vesting.releasable(token);
        withdrawAmount =
            token.balanceOf(address(vesting)) -
            finalReleasableAmount;
    }

    /*//////////////////////////////////////////////////////////////
                             withdrawUnvested
    //////////////////////////////////////////////////////////////*/

    function testCannotWithdrawUnvestedUnauthorized() external {
        address msgSender = address(0);

        assertTrue(msgSender != projectOwner);

        vm.expectRevert(Ownable.Unauthorized.selector);

        vesting.withdrawUnvested();
    }

    function testWithdrawUnvested() external {
        uint256 vestedPercent = 75;
        uint256 totalVestingAmount = 1e18;

        deal(token, address(vesting), totalVestingAmount);

        vm.warp(_getVestedTimestamp(vestedPercent));

        (
            uint256 finalReleasableAmount,
            uint256 withdrawAmount
        ) = _getWithdrawVestingAmounts();
        uint256 projectOwnerTokenBalanceBeforeWithdraw = token.balanceOf(
            projectOwner
        );
        uint256 beneficiaryTokenBalanceBeforeWithdraw = token.balanceOf(
            beneficiary
        );

        vm.prank(projectOwner);
        vm.expectEmit(true, false, false, true, address(vesting));

        emit ERC20Released(token, finalReleasableAmount);

        vesting.withdrawUnvested();

        assertEq(
            projectOwnerTokenBalanceBeforeWithdraw + withdrawAmount,
            token.balanceOf(projectOwner)
        );
        assertEq(
            beneficiaryTokenBalanceBeforeWithdraw + finalReleasableAmount,
            token.balanceOf(beneficiary)
        );
        assertEq(
            token.balanceOf(beneficiary) + token.balanceOf(projectOwner),
            projectOwnerTokenBalanceBeforeWithdraw +
                beneficiaryTokenBalanceBeforeWithdraw +
                totalVestingAmount
        );
        assertEq(0, token.balanceOf(address(vesting)));
    }

    function testWithdrawUnvestedFuzz(
        bool callReleaseFirst,
        uint8 vestedPercent,
        uint80 totalVestingAmount
    ) external {
        vm.assume(vestedPercent <= 100);
        vm.assume(totalVestingAmount != 0);

        deal(token, address(vesting), totalVestingAmount);

        vm.warp(_getVestedTimestamp(vestedPercent));

        if (callReleaseFirst) {
            vm.prank(beneficiary);

            vesting.release(token);
        }

        (
            uint256 finalReleasableAmount,
            uint256 withdrawAmount
        ) = _getWithdrawVestingAmounts();
        uint256 projectOwnerTokenBalanceBeforeWithdraw = token.balanceOf(
            projectOwner
        );
        uint256 beneficiaryTokenBalanceBeforeWithdraw = token.balanceOf(
            beneficiary
        );

        // Should be zero if the advisor already claimed their vested tokens.
        if (callReleaseFirst) assertEq(0, finalReleasableAmount);

        vm.prank(projectOwner);
        vm.expectEmit(true, false, false, true, address(vesting));

        emit ERC20Released(token, finalReleasableAmount);

        vesting.withdrawUnvested();

        console.log(
            "totalBalance",
            token.balanceOf(beneficiary) + token.balanceOf(projectOwner)
        );
        console.log("totalVestingAmount", totalVestingAmount);

        assertEq(
            projectOwnerTokenBalanceBeforeWithdraw + withdrawAmount,
            token.balanceOf(projectOwner)
        );
        assertEq(
            beneficiaryTokenBalanceBeforeWithdraw + finalReleasableAmount,
            token.balanceOf(beneficiary)
        );
        assertEq(
            token.balanceOf(beneficiary) + token.balanceOf(projectOwner),
            projectOwnerTokenBalanceBeforeWithdraw +
                beneficiaryTokenBalanceBeforeWithdraw +
                (finalReleasableAmount + withdrawAmount)
        );
        assertEq(0, token.balanceOf(address(vesting)));
    }
}
