// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DoSVulnerable {
    address[] public users;

    function addUser(address _user) public {
        users.push(_user);
    }

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
