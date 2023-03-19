// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/GoldCoin.sol";

contract GLDTokenATest is Test {
    GoldCoin public gold;
    address receiver = vm.addr(0x1);

    function setUp() public {
        gold = new GoldCoin();
    }

    function testName() public {
        assertEq("Gold Coin", gold.name());
    }

    function testTotalSupply() public {
        assertEq(gold.totalSupply(), 1 ether);
        gold.mint(receiver, 1 ether);
        assertEq(gold.balanceOf(receiver), 1 ether);
        assertEq(gold.totalSupply(), 2 ether);
    }

}