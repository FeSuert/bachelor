// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title RandomnessVulnerable
 * @dev Demonstrates a vulnerability in generating randomness on-chain
 */
contract RandomnessVulnerable {
    uint private nonce = 0;

    // Function to generate a "random" number
    function generateRandomNumber() public returns (uint) {
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % 100;
        nonce++;
        return random;
    }
}
