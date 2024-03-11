// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title TxOriginAuth
 * @dev Demonstrates a vulnerability using tx.origin for authentication
 */
contract TxOriginAuth {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public {
        // Vulnerable authentication check
        if (tx.origin == owner) {
            owner = _newOwner;
        }
    }
}

