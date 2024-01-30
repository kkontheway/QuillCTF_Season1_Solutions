// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "../../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract PoolToken is ERC20("loan token", "lnt"), Ownable {
    function mint(uint256 amount) external onlyOwner {
        _mint(msg.sender, amount);
    }
}
