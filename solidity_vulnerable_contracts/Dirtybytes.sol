pragma solidity 0.8.0;

contract Bytes {
    event ev(uint[], uint);
    bytes s;

    constructor() {
        emit ev(new uint[](2), 0);
        bytes memory m = new bytes(63);
        s = m;
    }

    function h() external returns (bytes memory) {
        s.push();
        return s;
    }
}

//Source: https://github.com/SunWeb3Sec/DeFiVulnLabs/blob/main/src/test/Dirtybytes.sol