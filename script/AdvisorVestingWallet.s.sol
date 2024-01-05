// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {AdvisorVestingWallet} from "src/AdvisorVestingWallet.sol";
import {IBRR} from "script/interfaces/IBRR.sol";

contract AdvisorVestingWalletScript is Script {
    IBRR private constant _BRR =
        IBRR(0x6d80d90ce251985bF41A98c6FDd6b7b975Fff884);

    // January 1, 2024, 12:00 PM EST.
    uint64 public constant _VESTING_START = 1704128400;

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        // For a list of our advisors and their vesting amounts:
        // https://docs.google.com/spreadsheets/d/1HEKMYYa_LeYzG87Li8gEu_-cR9mY9pTpoqe8MIhvU68/edit#gid=1253912565.
        address aintnoking = address(
            new AdvisorVestingWallet(
                0x334F95D8FFdB85a0297C6F7216E793d08ab45B48,
                _VESTING_START
            )
        );

        // 0.25% of the total supply.
        _BRR.transfer(aintnoking, 2_500_000e18);

        vm.stopBroadcast();
    }
}
