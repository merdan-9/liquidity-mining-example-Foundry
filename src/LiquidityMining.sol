// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import "openzeppelin-contracts/contracts/utils/math/SafeMath.sol";

contract LiquidityMining {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public token;
    uint256 public totalRewars;
    uint256 public totalDeposit;
    uint256 public rewardPerSec;
    uint256 public startTime;
    uint256 public endTime;
    mapping(address=>uint256) public balances;
    mapping(address=>uint256) public lastUpdateTime;
    // mapping(address => uint256) public rewards;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 amount);
    
    constructor(
        IERC20 _token,
        uint256 _totalRewards,
        uint256 _startTime,
        uint256 _endTime
    ) {
        require(_startTime < _endTime, "Invalid Timestamp");
        token = IERC20(_token);
        startTime = _startTime;
        endTime = _endTime;
        totalRewars = _totalRewards;
        rewardPerSec = totalRewars.div(endTime.sub(startTime));
    }

    function deposit(uint256 _amount) external {
        require(block.timestamp >= startTime, "Mining period has not started");
        require(block.timestamp < endTime, "Mining period has ended");
        require(_amount > 0, "Cannot deposit 0 token");
        token.safeTransferFrom(msg.sender, address(this), _amount);
        balances[msg.sender] = balances[msg.sender].add(_amount);
        totalDeposit = totalDeposit.add(_amount);
        emit Deposited(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) external {
        require(_amount > 0, "Cannot withdraw 0 token");
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        updateReward(msg.sender);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        totalDeposit = totalDeposit.sub(_amount);
        token.safeTransfer(msg.sender, _amount);
        emit Withdrawn(msg.sender, _amount);
    }

    function getReward() external {
        updateReward(msg.sender);
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        token.safeTransfer(msg.sender, amount);
        emit RewardPaid(msg.sender, amount);
    }

    function updateReward(address _user) public {
        if (totalDeposit == 0) {
            return;
        }
        uint256 timeSinceLastUpdate = block.timestamp.sub(lastUpdateTime[_user]);
        uint256 reward = timeSinceLastUpdate.mul(rewardPerSec).mul(balances[_user]).div(totalDeposit);
        balances[_user] = balances[_user].add(reward);
        lastUpdateTime[_user] = block.timestamp;
    }
}
