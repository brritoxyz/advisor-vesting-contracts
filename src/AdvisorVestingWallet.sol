// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Ownable} from "solady/auth/Ownable.sol";
import {VestingWallet} from "openzeppelin-contracts/finance/VestingWallet.sol";
import {SafeTransferLib} from "solady/utils/SafeTransferLib.sol";

contract AdvisorVestingWallet is Ownable, VestingWallet {
    using SafeTransferLib for address;

    address private constant _BRR = 0x6d80d90ce251985bF41A98c6FDd6b7b975Fff884;

    // Protocol address (ownership may be transferred at will).
    // Allows the protocol to withdraw the advisor tokens for ex-advisors.
    address private constant _INITIAL_OWNER =
        0x8Fcc36CCa8dE6E5d6c44d4de5F8fbCa86742e0af;

    // Advisor vesting starts on October 31, 2023 at 12:00pm EST.
    uint64 private constant _VESTING_START = 1698768000;

    // Advisor vesting ends on October 31, 2024 at 12:00pm EST.
    // 1730390400 - _VESTING_START = 31622400.
    uint64 private constant _VESTING_DURATION = 31622400;

    constructor(
        address beneficiaryAddress
    ) VestingWallet(beneficiaryAddress, _VESTING_START, _VESTING_DURATION) {
        _initializeOwner(_INITIAL_OWNER);
    }

    /**
     * @notice Transfer BRR back to the protocol with the releasable amount deducted.
     */
    function withdrawUnvested() external onlyOwner {
        _BRR.safeTransfer(
            owner(),
            _BRR.balanceOf(address(this)) - releasable(_BRR)
        );
    }

    // Overridden since advisors are compensated in BRR.
    function released() public view override returns (uint256) {}

    // Overridden since advisors are compensated in BRR.
    function releasable() public view override returns (uint256) {}

    // Overridden since advisors are compensated in BRR.
    function release() public override {}

    // Overridden since advisors are compensated in BRR.
    function vestedAmount(uint64) public view override returns (uint256) {}
}
