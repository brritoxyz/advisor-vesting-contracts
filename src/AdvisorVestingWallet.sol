// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {VestingWallet} from "openzeppelin-contracts/finance/VestingWallet.sol";

contract AdvisorVestingWallet is VestingWallet {
    // Advisor vesting starts on October 31, 2023 at 12:00pm EST.
    uint64 private constant _VESTING_START = 1698768000;

    // Advisor vesting ends on October 31, 2024 at 12:00pm EST.
    // 1730390400 - _VESTING_START = 31622400.
    uint64 private constant _VESTING_DURATION = 31622400;

    constructor(
        address beneficiaryAddress
    ) VestingWallet(beneficiaryAddress, _VESTING_START, _VESTING_DURATION) {}
}
