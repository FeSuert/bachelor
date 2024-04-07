// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ImproperAccessControl
 * @dev Demonstrates an improper access control vulnerability
 */
contract ImproperAccessControl {
    address public owner;
    uint public secretValue;

    constructor() {
        owner = msg.sender;
        secretValue = 42;
    }

    // Function intended to be called by the owner only
    function setSecretValue(uint _value) public {
        secretValue = _value;
    }

    // Function to check if caller is owner (intended for demonstration; flawed logic)
    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }
}



