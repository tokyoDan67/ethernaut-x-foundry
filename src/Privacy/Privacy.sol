// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract Privacy {

  bool public locked = true;  // 0th slot
  uint256 public ID = block.timestamp; // 1st slot
  // 2nd slot
  uint8 private flattening = 10; 
  uint8 private denomination = 255;
  uint16 private awkwardness = uint16(block.timestamp); // now is deprecated use block.timestamp instead
  // 3rd, 4th, 5th
  bytes32[3] private data;

  constructor(bytes32[3] memory _data) public {
    data = _data;
  }
  
  function unlock(bytes16 _key) public {
    require(_key == bytes16(data[2]));
    locked = false;
  }

  /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
  */
}