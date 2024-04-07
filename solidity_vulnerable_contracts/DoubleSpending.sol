pragma solidity 0.8.20;

abstract contract ReentrancyGuard {
    bool internal locked;

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }
}

interface IMoonToken {
    function buy(uint256 _amount) external payable;
    function sell(uint256 _amount) external;
    function transfer(address _to, uint256 _amount) external;
    function transferFrom(address _from, address _to, uint256 _value) external;
    function approve(address _spender, uint256 _value) external;
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);
    function getEtherBalance() external view returns (uint256);
    function getUserBalance(address _user) external view returns (uint256);
}

contract MoonToken {
    mapping (address => uint256) private userBalances;
    mapping (address => mapping (address => uint256)) private allowed;

    uint256 private constant MAX_UINT256 = type(uint256).max;
    uint256 public constant TOKEN_PRICE = 1 ether;

    string public constant name = "Moon Token";
    string public constant symbol = "MOON";

    // The token is non-divisible
    // You can buy/sell/transfer 1, 2, 3, or 46 tokens but not 33.5
    uint8 public constant decimals = 0;

    function buy(uint256 _amount) external payable {
        require(
            msg.value == _amount * TOKEN_PRICE, 
            "Ether submitted and Token amount to buy mismatch"
        );

        userBalances[msg.sender] += _amount;
    }

    function sell(uint256 _amount) external {
        require(userBalances[msg.sender] >= _amount, "Insufficient balance");

        userBalances[msg.sender] -= _amount;

        (bool success, ) = msg.sender.call{value: _amount * TOKEN_PRICE}("");
        require(success, "Failed to send Ether");
    }

    function transfer(address _to, uint256 _amount) external {
        require(_to != address(0), "_to address is not valid");
        require(userBalances[msg.sender] >= _amount, "Insufficient balance");
        
        userBalances[msg.sender] -= _amount;
        userBalances[_to] += _amount;
    }

    function transferFrom(address _from, address _to, uint256 _value) external {
        uint256 allowance_ = allowed[_from][msg.sender];
        require(
            userBalances[_from] >= _value && allowance_ >= _value, 
            "Insufficient balance"
        );

        userBalances[_to] += _value;
        userBalances[_from] -= _value;

        if (allowance_ < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
    }

    function approve(address _spender, uint256 _value) external {
        allowed[msg.sender][_spender] = _value;
    }

    function allowance(address _owner, address _spender)
        external
        view
        returns (uint256 remaining)
    {
        return allowed[_owner][_spender];
    }

    function getEtherBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getUserBalance(address _user) external view returns (uint256) {
        return userBalances[_user];
    }
}

contract InsecureMoonDAOVote is ReentrancyGuard {
    IMoonToken public immutable moonToken;
    uint256 public immutable voteDeadline;

    // User Vote 
    struct UserVote {
        uint256 candidateID;
        uint256 voteAmount;
        bool completed;
    }
    mapping (address => UserVote) private userVotes;

    // CEO Candidate
    struct CEOCandidate {
        string name;
        uint256 totalVoteAmount;
    }
    CEOCandidate[] private candidates;

    constructor(IMoonToken _moonToken, uint256 _voteDeadline) {
        moonToken = _moonToken;
        voteDeadline = _voteDeadline;

        // Candidate #0: Bob
        candidates.push(
            CEOCandidate({name: "Bob", totalVoteAmount: 0})
        );

        // Candidate #1: John
        candidates.push(
            CEOCandidate({name: "John", totalVoteAmount: 0})
        );

        // Candidate #2: Eve
        candidates.push(
            CEOCandidate({name: "Eve", totalVoteAmount: 0})
        );
    }

    function vote(uint256 _candidateID) external noReentrant {
        require(block.timestamp < voteDeadline, "Vote is finished");
        require(!userVotes[msg.sender].completed, "You have already voted");
        require(_candidateID < candidates.length, "Invalid candidate id");

        uint256 voteAmount = moonToken.getUserBalance(msg.sender);
        require(voteAmount > 0, "You have no privilege to vote");

        userVotes[msg.sender] = UserVote({
            candidateID: _candidateID,
            voteAmount: voteAmount,
            completed: true
        });

        candidates[_candidateID].totalVoteAmount += voteAmount;
    }

    function getTotalCandidates() external view returns (uint256) {
        return candidates.length;
    }

    function getUserVote(address _user) external view returns (UserVote memory) {
        return userVotes[_user];
    }

    function getCandidate(uint256 _candidateID) external view returns (CEOCandidate memory) {
        require(_candidateID < candidates.length, "Invalid candidate id");
        return candidates[_candidateID];
    }
}