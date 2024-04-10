// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SimplePool {
    uint public totalDebt;
    uint public lastAccrueInterestTime;
    uint public loanTokenBalance;

    constructor() {
        totalDebt = 10000e6;
        lastAccrueInterestTime = block.timestamp - 1;
        loanTokenBalance = 500e18;
    }

    function getCurrentReward() public view returns (uint _reward) {
        uint _timeDelta = block.timestamp - lastAccrueInterestTime;

        if (_timeDelta == 0) return 0;

        _reward = (totalDebt * _timeDelta) / (365 days * 1e18);
        _reward;
    }
}

//Source: https://github.com/SunWeb3Sec/DeFiVulnLabs/blob/main/src/test/Precision-loss.sol