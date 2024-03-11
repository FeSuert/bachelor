// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Timestamp {
    uint public lastUpdateTime;
    uint public value;

    constructor() {
        lastUpdateTime = block.timestamp;
        value = 0;
    }

    function updateValue(uint _newValue) public {
        require(block.timestamp >= lastUpdateTime + 1 minutes, "Too soon to update");
        
        lastUpdateTime = block.timestamp;
        value = _newValue;
    }

    function canUpdate() public view returns (bool) {
        return block.timestamp >= lastUpdateTime + 1 minutes;
    }
}
