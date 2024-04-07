// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Token {
    mapping(address => uint256) public balances;

    constructor() {
        // Initial token distribution
        balances[msg.sender] = 1000;
    }

    function transfer(address _to, uint256 _value) public {
        require(balances[msg.sender] >= _value, "Insufficient balance");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
    }
}
