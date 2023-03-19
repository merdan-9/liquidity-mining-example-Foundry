// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/LiquidityMining.sol";
import "../src/GoldCoin.sol";

contract Deploy is Script {

    function run() public {

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        GoldCoin gold = new GoldCoin();
        uint256 startTime = block.timestamp;
        uint256 endTime = startTime + 365 * 24 * 60 * 60;
        uint256 totalRewards = 100 ether;
        LiquidityMining liquidityMining = new LiquidityMining(gold, totalRewards, startTime, endTime);
        gold.mint(address(liquidityMining), 100 ether);
        vm.stopBroadcast();
    }
}
