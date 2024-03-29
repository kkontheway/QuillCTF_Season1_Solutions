// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Confidential {
    string public firstUser = "ALICE"; //0
    uint256 public alice_age = 24; //1
    bytes32 private ALICE_PRIVATE_KEY; //Super Secret Key//2
    bytes32 public ALICE_DATA = "QWxpY2UK"; //3
    bytes32 private aliceHash = hash(ALICE_PRIVATE_KEY, ALICE_DATA); //4

    string public secondUser = "BOB"; //5
    uint256 public bob_age = 21; //6
    bytes32 private BOB_PRIVATE_KEY; // Super Secret Key//7
    bytes32 public BOB_DATA = "Qm9iCg"; //8
    bytes32 private bobHash = hash(BOB_PRIVATE_KEY, BOB_DATA); //9

    constructor() {}

    function hash(bytes32 key1, bytes32 key2) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(key1, key2));
    }

    function checkthehash(bytes32 _hash) public view returns (bool) {
        require(_hash == hash(aliceHash, bobHash));
        return true;
    }
}
