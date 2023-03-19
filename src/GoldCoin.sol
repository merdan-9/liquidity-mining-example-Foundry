// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";



contract GoldCoin is ERC20, Ownable {
    constructor() ERC20("Gold Coin", "GOLD") {
        _mint(msg.sender, 1 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}