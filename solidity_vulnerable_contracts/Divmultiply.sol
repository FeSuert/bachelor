pragma solidity ^0.8.18;

contract Calculation1 {
    function price(
        uint256 price,
        uint256 discount
    ) public pure returns (uint256) {
        return (price / 100) * discount;
    }
}

contract Calculation2 {
    function price(
        uint256 price,
        uint256 discount
    ) public pure returns (uint256) {
        return (price * discount) / 100;
    }
}

//Source: https://github.com/SunWeb3Sec/DeFiVulnLabs/blob/main/src/test/Divmultiply.sol