pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../MagicNum/MagicNumFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract MagicNumTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testMagicNum() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        MagicNumFactory magicNumFactory = new MagicNumFactory();
        ethernaut.registerLevel(magicNumFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(magicNumFactory);
        MagicNum ethernautMagicNum = MagicNum(payable(levelAddress));


        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Key:
        // PUSH2 = 
        // CODECOPY = 39

        // INIT CODE
        // Copy the runtime code to memory...

        // PUSH1 0A
        // DUP1
        // PUSH1 ** Insert where the runtime starts **
        // PUSH1 00
        // CODECOPY
        // Return the runtime code...
        // PUSH1 00 
        // RETURN 
        // STOP 

        // "\x60\x0A\x80\x60\x0C\x60\x00\x39\x60\x00\xF3\x00\x60\x42\x60\x80\x52\x60\x80\x60\x01\xF3"

        // RUNTIME CODE
        // Store 42 at the free memory pointer...
        // PUSH1 42
        // PUSH1 80
        // MSTORE 
        // Return 42...
        // PUSH1 01
        // PUSH1 80
        // RETURN
        // "\x60\x42\x60\x80\x52\x60\x20\x60\x80\xF3"


        bytes memory code = "\x60\x0A\x80\x60\x0C\x60\x00\x39\x60\x00\xF3\x00\x60\x2A\x60\x80\x52\x60\x20\x60\x80\xF3";
        address addr;
        assembly {
          // First 32 are save for size ?
          addr := create(0, add(code, 0x20), mload(code))
          if iszero(extcodesize(addr)) {
            revert(0, 0)
          }
        }
        ethernautMagicNum.setSolver(addr);


        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
