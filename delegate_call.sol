// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title DelegatecallVulnerable
 * @dev Demonstrates a vulnerability to delegatecall injection
 */
contract DelegatecallVulnerable {
    address public owner;
    uint public someValue;

    constructor() {
        owner = msg.sender;
    }

    function setOwner(address _newOwner) public {
        owner = _newOwner;
    }

    function delegatecallSetOwner(address _target, bytes memory _data) public {
        // Vulnerable delegatecall usage
        (bool success, ) = _target.delegatecall(_data);
        require(success, "Delegatecall failed");
    }
}

// Malicious contract that could be used to exploit the vulnerability
contract Attack {
    address public owner;
    uint public someValue;

    // This function's signature matches setOwner in the vulnerable contract
    function setOwner(address _newOwner) public {
        owner = _newOwner;
    }
}



