// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

/**
 * @title ArithmeticOverflowUnderflow
 * @dev Demonstrates an arithmetic overflow and underflow vulnerability
 */
contract ArithmeticOverflowUnderflow {
    // Vulnerable to underflow
    function subtract(uint _a, uint _b) public pure returns (uint) {
        return _a - _b;
    }

    // Vulnerable to overflow
    function add(uint _a, uint _b) public pure returns (uint) {
        return _a + _b;
    }
}