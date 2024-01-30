// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/16-GoldNFT/GoldNFT.sol";
import "../src/16-GoldNFT/HackGoldNft.sol";

contract Hack is Test {
    GoldNFT nft;
    HackGoldNft exp;
    address owner = makeAddr("owner");
    address hacker = makeAddr("hacker");

    function setUp() external {
        vm.createSelectFork("goerli", 8591866);
        nft = new GoldNFT();
    }

    function test_Attack() public {
        vm.startPrank(hacker);
        // solution
        exp = new HackGoldNft();
        exp.exploit(address(nft));
        assertEq(nft.balanceOf(hacker), 10);
    }
}
