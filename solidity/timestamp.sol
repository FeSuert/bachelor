// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title TimestampDependence
 * @dev Demonstrates a vulnerability due to reliance on block.timestamp
 */
contract TimestampDependence {
    uint public lastUpdateTime;
    uint public value;

    constructor() {
        lastUpdateTime = block.timestamp;
        value = 0;
    }

    // Function that updates value if at least 1 minute has passed
    function updateValue(uint _newValue) public {
        require(block.timestamp >= lastUpdateTime + 1 minutes, "Too soon to update");
        
        lastUpdateTime = block.timestamp;
        value = _newValue;
    }

    // Function to check if enough time has passed since the last update
    function canUpdate() public view returns (bool) {
        return block.timestamp >= lastUpdateTime + 1 minutes;
    }
}
