pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../King/KingHackDan.sol";
import "../King/KingFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract KingTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;
    address eoaAddress = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(eoaAddress, 5 ether);
    }

    function testKingHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        KingFactory kingFactory = new KingFactory();
        ethernaut.registerLevel(kingFactory);
        vm.startPrank(eoaAddress);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(kingFactory);
        King ethernautKing = King(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        KingHackDan hack = new KingHackDan(levelAddress);
        hack.pwnKing{value: 1 ether}();

        assertEq(ethernautKing._king(), address(hack), "Wrong king");
        assertEq(ethernautKing.prize(), 1 ether, "Wrong prize");

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}