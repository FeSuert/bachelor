// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title GasLimitLoops
 * @dev Demonstrates a potential gas limit issue with loops
 */
contract GasLimitLoops {
    uint[] public largeArray;

    // Function to add elements to the array
    function addToLargeArray(uint _element) public {
        largeArray.push(_element);
    }

    // Function that iterates over the largeArray and performs operations
    function processLargeArray() public {
        for(uint i = 0; i < largeArray.length; i++) {
            // Imagine some complex operations here
            largeArray[i] += 2;
        }
    }
}


