// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Array {
    mapping(address => UserInfo) public userInfo;

    struct UserInfo {
        uint256 amount;
        uint256 rewardDebt;
    }

    function updaterewardDebt(uint amount) public {
        UserInfo memory user = userInfo[msg.sender];
        user.rewardDebt = amount;
    }

    function fixedupdaterewardDebt(uint amount) public {
        UserInfo storage user = userInfo[msg.sender];
        user.rewardDebt = amount;
    }
}

//Source: https://github.com/SunWeb3Sec/DeFiVulnLabs/blob/main/src/test/DataLocation.sol