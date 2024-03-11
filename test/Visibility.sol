// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "forge-std/Test.sol";

contract ownerGame {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _new) public {
        owner = _new;
    }
}
