// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title DoSVulnerable
 * @dev Demonstrates a Denial of Service vulnerability via an unbounded loop
 */
contract DoSVulnerable {
    address[] public users;

    // Function to add a user to the contract
    function addUser(address _user) public {
        users.push(_user);
    }

    // Vulnerable function with an unbounded loop
    function findAndRemoveUser(address _user) public {
        uint length = users.length;
        for (uint i = 0; i < length; i++) {
            if (users[i] == _user) {
                users[i] = users[length - 1];
                users.pop();
                break;
            }
        }
    }
}


