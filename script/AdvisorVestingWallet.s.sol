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
        address theLlamasTreasury = address(
            new AdvisorVestingWallet(0x04467245D8d0BcF3a482af9e72fC4492C91f683E)
        );
        address theLlamasCore = address(
            new AdvisorVestingWallet(0x1C2D4fD89Fa7555945A85C690A601bF28275292A)
        );
        address vectorized = address(
            new AdvisorVestingWallet(0x1F5D295778796a8b9f29600A585Ab73D452AcB1c)
        );
        address cogsy = address(
            new AdvisorVestingWallet(0x36bFF079a4532C2F818a65c6ad208cEA587417e7)
        );
        address kimboCharlie = address(
            new AdvisorVestingWallet(0xd334533980C201c1b93e39bBE6bD1E04be5C0f5D)
        );
        address kimbo0xFelix = address(
            new AdvisorVestingWallet(0x54F65A11Ac61dE39DC70379a3CA0FA268EEf952c)
        );
        address kimboIrate = address(
            new AdvisorVestingWallet(0x8625AfdbF3744D433D850c681Ba881d028253c8A)
        );
        address kimboJustJousting = address(
            new AdvisorVestingWallet(0x8561AeDA4Df9739980A7D09044DdF15694D00711)
        );
        address nap = address(
            new AdvisorVestingWallet(0x6531C0f565A451dB7d2409937230C4f153812953)
        );
        address proteccLabsKris = address(
            new AdvisorVestingWallet(0xb9D83D298D46C4dd73618F19a2A40084Ce36476a)
        );
        address proteccLabsMagnus = address(
            new AdvisorVestingWallet(0x065CcE43ff745e6364669D46eF73ba6236f1A75c)
        );
        address feistyDogeDAO = address(
            new AdvisorVestingWallet(0x1d4B9b250B1Bd41DAA35d94BF9204Ec1b0494eE3)
        );
        address pyk = address(
            new AdvisorVestingWallet(0x17ae0a6BE2e97b384165626dB2569729d5006640)
        );
        address llamaAirforce = address(
            new AdvisorVestingWallet(0x375B28A603Be144a646A506fB6673cc3182fC8Df)
        );

        _BRR.mint(theLlamasTreasury, 20_000_000e18);
        _BRR.mint(theLlamasCore, 10_000_000e18);
        _BRR.mint(vectorized, 10_000_000e18);
        _BRR.mint(cogsy, 2_500_000e18);
        _BRR.mint(kimboCharlie, 625_000e18);
        _BRR.mint(kimbo0xFelix, 625_000e18);
        _BRR.mint(kimboIrate, 625_000e18);
        _BRR.mint(kimboJustJousting, 625_000e18);
        _BRR.mint(nap, 2_500_000e18);
        _BRR.mint(proteccLabsKris, 500_000e18);
        _BRR.mint(proteccLabsMagnus, 500_000e18);
        _BRR.mint(feistyDogeDAO, 1_000_000e18);
        _BRR.mint(pyk, 2_500_000e18);
        _BRR.mint(llamaAirforce, 5_000_000e18);

        // The advisors below have not provided us with a new Gnosis Safe address on Base.
        // The below will be updated as we receive their new addresses.
        // address questDAO = address(
        //     new AdvisorVestingWallet(0xAE84Ea7997dfEefE77Cd39f88E2416A019F0541e)
        // );
        // address ribbonatiDAO = address(
        //     new AdvisorVestingWallet(0xFb2CE50C4c8024E037e6be52dd658E2Be23d93Db)
        // );

        // _BRR.mint(questDAO, 1_000_000e18);
        // _BRR.mint(ribbonatiDAO, 100_000e18);

        vm.stopBroadcast();
    }
}
