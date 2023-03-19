// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

import "../src/LiquidityMining.sol";
import "../src/GoldCoin.sol";

contract LiquidityMiningTest is Test {
    LiquidityMining public liquidityMining;
    GoldCoin public gold;
    uint256 startTime;
    uint256 endTime;
    uint256 totalRewards;
    address user1;

    function setUp() public {
        gold = new GoldCoin();
        startTime = block.timestamp;
        endTime = startTime + 1000;
        totalRewards = 1000 ether;
        liquidityMining = new LiquidityMining(gold, totalRewards, startTime, endTime);
        gold.mint(address(liquidityMining), 100 ether);

        user1 = makeAddr("user1");    
    }

    function testDeposit() public {
        gold.mint(user1, 10 ether);
        assertEq(gold.balanceOf(user1), 10 ether);

        startHoax(user1);
        gold.approve(address(liquidityMining), 100 ether);
        liquidityMining.deposit(1 ether);
        assertEq(gold.balanceOf(user1), 9 ether);
        assertEq(liquidityMining.totalDeposit(), 1 ether);
        skip(10);
        liquidityMining.updateReward(user1);
        assertEq(liquidityMining.balances(user1), 12 ether);
        assertEq(liquidityMining.totalDeposit(), 1 ether);
        liquidityMining.withdraw(1 ether);
        assertEq(liquidityMining.totalDeposit(), 0);
        assertEq(gold.balanceOf(user1), 10 ether);
        liquidityMining.getReward();
        assertEq(gold.balanceOf(user1), 21 ether);
    }


}
