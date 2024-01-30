// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/6-Collatzpuzzle/Collatzpuzzle.sol";

contract Attack {
    function deploy() public returns (address) {
        bytes memory con = hex"7f6002600435818106156015576003026001016017565b045b60005260206000f360005260206000f3";
        address addr;
        assembly {
            addr := create(0, add(con, 0x20), 0x29)
        }
        return addr;
    }
}

contract testCollatz is Test {
    CollatzPuzzle public cz;
    address attacker;

    function setUp() public {
        attacker = vm.addr(1);
        cz = new CollatzPuzzle();
    }

    function testExploit() public {
        vm.startPrank(attacker);
        Attack att = new Attack();
        address taddr = att.deploy();
        bool ans = cz.callMe(taddr);
        vm.stopPrank();
        assert(ans == true);
    }
}
