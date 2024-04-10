// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ownerGame { 
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _new) public {
        owner = _new;
    }
}

//Source: https://github.com/SunWeb3Sec/DeFiVulnLabs/blob/main/src/test/Visibility.sol