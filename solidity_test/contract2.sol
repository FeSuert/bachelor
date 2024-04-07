pragma solidity 0.6.10;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface ISprout {
    function treasuryDAO() external view returns (address treasury);
}

contract TreasuryDrip {
    IERC20 public Token;
    uint256 public blocklock;
    ISprout public bucket;

    constructor(IERC20 Tokent, ISprout buckt) public {
        Token = Tokent;
        bucket = buckt;
    }

    function tap() public {
        Token.transfer(
            bucket.treasuryDAO(),
            Token.balanceOf(address(this)) / 100
        );
        require(blocklock <= now, "block");
        blocklock = now + 1 days;
    }
}
