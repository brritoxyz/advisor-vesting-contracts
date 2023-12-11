// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {AdvisorVestingWallet} from "src/AdvisorVestingWallet.sol";
import {IBRR} from "script/interfaces/IBRR.sol";

contract AdvisorVestingWalletScript is Script {
    IBRR private constant _BRR =
        IBRR(0x6d80d90ce251985bF41A98c6FDd6b7b975Fff884);

    // December 1, 2023, 12:00 PM EST.
    uint64 public constant _VESTING_START = 1701450000;

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        // For a list of our advisors and their vesting amounts:
        // https://docs.google.com/spreadsheets/d/1HEKMYYa_LeYzG87Li8gEu_-cR9mY9pTpoqe8MIhvU68/edit#gid=1253912565.
        address joeySantoro = address(
            new AdvisorVestingWallet(
                // The previous advisor vesting wallet had its tokens withdrawn, and is being
                // redeployed with the following Gnosis Safe address.
                0x4343F82Ccd66d37961486Bd054d3DB31f1197540,
                _VESTING_START
            )
        );

        _BRR.transfer(joeySantoro, 2_500_000e18);

        vm.stopBroadcast();
    }
}
