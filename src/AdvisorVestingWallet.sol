// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Ownable} from "solady/auth/Ownable.sol";
import {VestingWallet} from "openzeppelin-contracts/finance/VestingWallet.sol";
import {SafeTransferLib} from "solady/utils/SafeTransferLib.sol";

/**
 * @notice OpenZeppelin's VestingWallet with the following changes:
 * - The project owner address can withdraw unvested BRR to end the relationship with an advisor.
 * - ETH-related methods are overridden and do nothing, since advisors are compensated in BRR.
 *
 * For a list of our advisors and their vesting amounts:
 * https://docs.google.com/spreadsheets/d/1HEKMYYa_LeYzG87Li8gEu_-cR9mY9pTpoqe8MIhvU68/edit#gid=1253912565.
 */
contract AdvisorVestingWallet is Ownable, VestingWallet {
    using SafeTransferLib for address;

    // Project address (ownership may be transferred at will).
    // Allows the project owner to withdraw the advisor tokens for ex-advisors.
    address private constant _INITIAL_OWNER =
        0x8Fcc36CCa8dE6E5d6c44d4de5F8fbCa86742e0af;

    // Advisor vesting starts on October 31, 2023 at 12:00pm EST.
    uint64 private constant _VESTING_START = 1_698_768_000;

    // Advisor vesting ends on October 31, 2024 at 12:00pm EST.
    // 1730390400 - _VESTING_START = 31622400.
    uint64 private constant _VESTING_DURATION = 31_622_400;

    // BRR token contract.
    address public constant TOKEN = 0x6d80d90ce251985bF41A98c6FDd6b7b975Fff884;

    event WithdrawUnvested(
        uint256 finalReleasableAmount,
        uint256 withdrawAmount
    );

    constructor(
        address beneficiaryAddress
    ) VestingWallet(beneficiaryAddress, _VESTING_START, _VESTING_DURATION) {
        _initializeOwner(_INITIAL_OWNER);
    }

    /**
     * @notice Transfer the final amount to the beneficiary and the remainder to the owner.
     */
    function withdrawUnvested() external onlyOwner {
        release(TOKEN);
        TOKEN.safeTransfer(owner(), TOKEN.balanceOf(address(this)));
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
