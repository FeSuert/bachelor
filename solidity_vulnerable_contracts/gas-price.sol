// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract GasReimbursement {
    uint public gasUsed = 100000; 
    uint public GAS_OVERHEAD_NATIVE = 500;

    function calculateTotalFee() public view returns (uint) {
        uint256 totalFee = (gasUsed + GAS_OVERHEAD_NATIVE) * tx.gasprice;
        return totalFee;
    }

    function executeTransfer(address recipient) public {
        uint256 totalFee = calculateTotalFee();
        _nativeTransferExec(recipient, totalFee);
    }

    function _nativeTransferExec(address recipient, uint256 amount) internal {
        payable(recipient).transfer(amount);
    }
}

//Source: https://github.com/SunWeb3Sec/DeFiVulnLabs/blob/main/src/test/gas-price.sol