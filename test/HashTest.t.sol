// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/2-Confidential_Hash/Confidential_Hash.sol";

contract testCon is Test, Confidential {
    Confidential challenge;

    function setUp() public {
        challenge = new Confidential();
    }

    function testConfidential() public {
        bytes32 aliceHash = vm.load(address(challenge), bytes32(uint256(4)));
        bytes32 bobHash = vm.load(address(challenge), bytes32(uint256(9)));
        bytes32 hash_value = challenge.hash(aliceHash, bobHash);

        bool isOK = challenge.checkthehash(hash_value);
        assert(isOK == true);
    }
}
