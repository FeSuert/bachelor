/** 
 * Submitted for verification at Etherscan.io on 2021-05-10 
 */ 

/** 
 * Submitted for verification at Etherscan.io on 2021-03-01 
 */ 

/** 
 * Submitted for verification at Etherscan.io on 2020-12-21 
 */ 

// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.7.6; 

interface IERC20 { 
    function totalSupply() external view returns (uint); 
    function balanceOf(address account) external view returns (uint); 
    function transfer(address recipient, uint amount) external returns (bool); 
    function allowance(address owner, address spender) external view returns (uint); 
    function approve(address spender, uint amount) external returns (bool); 
    function transferFrom(address sender, address recipient, uint amount) external returns (bool); 
    event Transfer(address indexed from, address indexed to, uint value); 
    event Approval(address indexed owner, address indexed spender, uint value); 
} 

contract Context { 
    constructor () public { } 

    // solhint-disable-previous-line no-empty-blocks 
    function _msgSender() internal view returns (address payable) { 
        return msg.sender; 
    } 
} 

contract ERC20 is Context, IERC20 { 
    using SafeMath for uint; 

    mapping (address => uint) public _balances; 
    mapping (address => mapping (address => uint)) public _allowances; 
    uint public _totalSupply; 

    function totalSupply() public view override returns (uint) { 
        return _totalSupply; 
    } 

    function balanceOf(address account) public view override returns (uint) { 
        return _balances[account]; 
    } 

    function transfer(address recipient, uint amount) public override returns (bool) { 
        _transfer(_msgSender(), recipient, amount); 
        return true; 
    } 

    function allowance(address owner, address spender) public view override returns (uint) { 
        return _allowances[owner][spender]; 
    } 

    function approve(address spender, uint amount) public override returns (bool) { 
        _approve(_msgSender(), spender, amount); 
        return true; 
    } 

    function transferFrom(address sender, address recipient, uint amount) public override returns (bool) { 
        _transfer(sender, recipient, amount); 
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")); 
        return true; 
    } 

    function increaseAllowance(address spender, uint addedValue) public returns (bool) { 
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue)); 
        return true; 
    } 

    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) { 
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero")); 
        return true; 
    } 

    function _transfer(address sender, address recipient, uint amount) internal { 
        require(sender != address(0), "ERC20: transfer from the zero address"); 
        require(recipient != address(0), "ERC20: transfer to the zero address"); 
        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance"); 
        _balances[recipient] = _balances[recipient].add(amount); 
        emit Transfer(sender, recipient,amount); 
    } 

    function _approve(address owner, address spender, uint amount) internal { 
        require(owner != address(0), "ERC20: approve from the zero address"); 
        require(spender != address(0), "ERC20: approve to the zero address"); 
        _allowances[owner][spender] = amount; 
        emit Approval(owner, spender, amount); 
    } 
} 

contract ERC20Detailed is ERC20 { 
    string private _name; 
    string private _symbol; 
    uint8 private _decimals; 

    constructor (string memory name, string memory symbol, uint8 decimals) public{ 
        _name = name; 
        _symbol = symbol; 
        _decimals = decimals; 
    } 

    function name() public view returns (string memory) { 
        return _name; 
    } 

    function symbol() public view returns (string memory) { 
        return _symbol; 
    } 

    function decimals() public view returns (uint8) { 
        return _decimals; 
    } 
} 

library SafeMath { 
    function add(uint a, uint b) internal pure returns (uint) { 
        uint c = a + b; 
        require(c >= a, "SafeMath: addition overflow"); 
        return c; 
    } 

    function sub(uint a, uint b) internal pure returns (uint) { 
        return sub(a, b, "SafeMath: subtraction overflow"); 
    } 

    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) { 
        require(b <= a, errorMessage); 
        uint c = a - b; 
        return c; 
    } 

    function mul(uint a, uint b) internal pure returns (uint) { 
        if (a == 0) { 
            return 0; 
        } 
        uint c = a * b; 
        require(c / a == b, "SafeMath: multiplication overflow"); 
        return c; 
    } 

    function div(uint a, uint b) internal pure returns (uint) { 
        return div(a, b, "SafeMath: division by zero"); 
    } 

    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) { 
        require(b > 0, errorMessage); 
        uint c = a / b; 
        return c; 
    } 
} 

library Address { 
    function isContract(address account) internal view returns (bool) { 
        bytes32 codehash; 
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470; 
        // solhint-disable-next-line no-inline-assembly 
        assembly { 
            codehash := extcodehash(account) 
        } 
        return (codehash != 0x0 && codehash != accountHash); 
    } 
} 

library SafeERC20 { 
    using SafeMath for uint; 
    using Address for address; 

    function safeTransfer(IERC20 token, address to, uint value) internal { 
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value)); 
    } 

    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal { 
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value)); 
    } 

    function safeApprove(IERC20 token, address spender, uint value) internal { 
        require((value == 0) || (token.allowance(address(this), spender) == 0), "SafeERC20: approve from non-zero to non-zero allowance" ); 
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value)); 
    } 

    function callOptionalReturn(IERC20 token, bytes memory data) private { 
        require(address(token).isContract(), "SafeERC20: call to non-contract"); 
        (bool success, bytes memory returndata) = address(token).call(data); 
        require(success, "SafeERC20: low-level call failed"); 
        if (returndata.length > 0) { 
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed"); 
        } 
    } 
} 

contract BOTS is ERC20, ERC20Detailed { 
    using SafeERC20 for IERC20; 
    using Address for address; 
    using SafeMath for uint; 
    address public ownership; 

    constructor () ERC20Detailed("Botcoin", "BOTS", 18) public{ 
        ownership = msg.sender; 
        _totalSupply = 100000000 *(10**uint256(18)); 
        _balances[ownership] = _totalSupply; 
    } 
} 

contract Owned is Context { 
    address private _owner; 
    address private _previousOwner; 
    uint256 private _lockTime; 
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); 

    constructor () { 
        address msgSender = _msgSender(); 
        _owner = msgSender; 
        emit OwnershipTransferred(address(0), msgSender); 
    } 

    function owner() public view returns (address) { 
        return _owner; 
    } 

    modifier onlyOwner() { 
        require(_owner == _msgSender(), "Ownable: caller is not the owner"); 
        _; 
    } 

    function renounceOwnership() public virtual onlyOwner { 
        emit OwnershipTransferred(_owner, address(0)); 
        _owner = address(0); 
    } 

    function transferOwnership(address newOwner) public virtual onlyOwner { 
        require(newOwner != address(0), "Ownable: new owner is the zero address"); 
        emit OwnershipTransferred(_owner, newOwner); 
        _owner = newOwner; 
    } 
} 

contract AirDrop is Owned { 
    using SafeMath for uint256; 
    uint256 public claimedTokens = 0; 
    IERC20 public airdropToken; 
    mapping (address => bool) public airdropReceivers; 
    event AirDropped ( address[] _recipients, uint256 _amount, uint256 claimedTokens); 

    constructor(IERC20 _token) public { 
        airdropToken = _token; 
    } 

    function airDrop(address[] memory _recipients, uint256 _amount) external onlyOwner { 
        require(_amount > 0); 
        uint256 airdropped; 
        uint256 amount = _amount * uint256(18); 
        for (uint256 index = 0; index < _recipients.length; index++) { 
            if (!airdropReceivers[_recipients[index]]) { 
                airdropReceivers[_recipients[index]] = true; 
                airdropToken.transfer(_recipients[index], amount); 
                airdropped = airdropped.add(amount); 
            } 
        } 
        claimedTokens = claimedTokens.add(airdropped); 
        emit AirDropped(_recipients, _amount, claimedTokens); 
    } 
}
