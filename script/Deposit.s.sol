// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/LiquidityMining.sol";
import "../src/GoldCoin.sol";

contract Deposit is Script {

    function run() public {

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        address gold_addr = 0xd3202fDa3b3CBa656918400019CE88678cA4e4a7;
        address liquidityMining_addr = 0x9f11d7E82315421D77330F8D6e76725db61dc5b7;
        LiquidityMining liquidityMining = LiquidityMining(liquidityMining_addr);
        GoldCoin gold = GoldCoin(gold_addr);
        gold.approve(address(liquidityMining), 100 ether);
        liquidityMining.deposit(1 ether);
        vm.stopBroadcast();
    }
}
