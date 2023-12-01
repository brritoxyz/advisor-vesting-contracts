// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {AdvisorVestingWallet} from "src/AdvisorVestingWallet.sol";
import {IBRR} from "script/interfaces/IBRR.sol";

contract AdvisorVestingWalletScript is Script {
    IBRR private constant _BRR =
        IBRR(0x6d80d90ce251985bF41A98c6FDd6b7b975Fff884);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        // For a list of our advisors and their vesting amounts:
        // https://docs.google.com/spreadsheets/d/1HEKMYYa_LeYzG87Li8gEu_-cR9mY9pTpoqe8MIhvU68/edit#gid=1253912565.
        address joeySantoro = address(
            new AdvisorVestingWallet(0x7E47dF2a371fA3488963E30bc914942eDcC48Fe5)
        );

        // The two advisors below have had their allocations updated.
        address cogsy = address(
            new AdvisorVestingWallet(0x36bFF079a4532C2F818a65c6ad208cEA587417e7)
        );
        address nap = address(
            new AdvisorVestingWallet(0x6531C0f565A451dB7d2409937230C4f153812953)
        );

        _BRR.transfer(joeySantoro, 2_500_000e18);

        // Each advisor below has already received a portion of their advisor tokens, the amounts below are the remainder.
        _BRR.transfer(cogsy, 295_434e18);
        _BRR.transfer(nap, 295_430e18);

        vm.stopBroadcast();
    }
}
