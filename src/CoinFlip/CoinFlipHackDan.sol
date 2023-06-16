// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10; // Latest solidity version

import 'openzeppelin-contracts/contracts/utils/math/SafeMath.sol'; // Path change of openzeppelin contract


contract CoinFlipHackDan {
    using SafeMath for uint256;

    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function getCorrectFlip() external view returns(bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue.div(FACTOR);
        return coinFlip == 1 ? true : false;
    }
}