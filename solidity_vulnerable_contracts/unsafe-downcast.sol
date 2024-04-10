// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SimpleBank {
    mapping(address => uint) private balances;

    function deposit(uint256 amount) public {
        uint8 balance = uint8(amount);

        balances[msg.sender] = balance;
    }

    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
}

//Source: https://github.com/SunWeb3Sec/DeFiVulnLabs/blob/main/src/test/unsafe-downcast.sol