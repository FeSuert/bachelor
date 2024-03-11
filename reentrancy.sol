// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ReentrancyVulnerable
 * @dev This contract is intentionally vulnerable to reentrancy attacks.
 */
contract ReentrancyVulnerable {
    mapping(address => uint256) public balances;

    // Function to deposit Ether into the contract
    function deposit() public payable {
        require(msg.value > 0, "Deposit value must be greater than 0");
        balances[msg.sender] += msg.value;
    }

    // Vulnerable withdraw function
    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // Vulnerability: External call before updating the state
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send Ether");

        // State update after the external call
        balances[msg.sender] -= _amount;
    }

    // Function to check the contract's Ether balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}



