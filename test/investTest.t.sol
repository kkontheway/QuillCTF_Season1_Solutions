// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/19-invet-pool/PoolToken.sol";
import "../src/19-invet-pool/InvestPool.sol";

contract Hack is Test {
    PoolToken token;
    InvestPool pool;
    address user = vm.addr(1);
    address hacker = vm.addr(2);

    function setUp() external {
        token = new PoolToken();
        pool = new InvestPool(address(token));

        token.mint(2000e18);
        token.transfer(user, 1000e18);
        token.transfer(hacker, 1000e18);

        vm.prank(user);
        token.approve(address(pool), type(uint256).max);

        vm.prank(hacker);
        token.approve(address(pool), type(uint256).max);
    }

    function userDeposit(uint256 amount) public {
        vm.prank(user);
        pool.deposit(amount);
        vm.stopPrank();
    }

    function test_hack() public {
        uint256 hackerBalanceBeforeHack = token.balanceOf(hacker);
        vm.startPrank(hacker);

        // solution

        vm.stopPrank();
        assertGt(token.balanceOf(hacker), hackerBalanceBeforeHack);
    }
}
