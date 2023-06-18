pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Reentrance/ReentranceHackDan.sol";
import "../Reentrance/ReentranceFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract ReentranceTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 3 ether);
    }

    function testReentranceHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        ReentranceFactory reentranceFactory = new ReentranceFactory();
        ethernaut.registerLevel(reentranceFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(reentranceFactory);
        Reentrance ethernautReentrance = Reentrance(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        ReentranceHackDan hack = new ReentranceHackDan{value: 1 ether}(levelAddress);

        assertEq(address(hack).balance, 1 ether, "Wrong hack balance");

        hack.pwnContract();

        assertEq(levelAddress.balance, 0, "Didn't fully drain balance");

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}