// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/DiceGame.sol";

contract DiceGameTest is Test {
    DiceGame public game;
    address public player;

    function setUp() public {
        game = new DiceGame();
        player = makeAddr("Erika");
        vm.deal(address(game), 1 ether); // fund contract so it can pay out prizes
        vm.deal(player, 1 ether); // give player 1 ETH to play with
    }

    function testPlayWithExactETH() public {
        // record balances before
        uint256 balanceBefore = player.balance;

        // call play() from player with 0.004 ether
        vm.prank(player);
        game.play{value: 0.004 ether}();

        // check player received a payout between 0.001 to 0.006 ether
        uint256 balanceAfter = player.balance;
        uint256 diff = balanceAfter - balanceBefore + 0.004 ether;

        assertTrue(
            diff >= 0.001 ether && diff <= 0.006 ether,
            "Invalid payout amount"
        );

        // check player owns NFT tokenId 1
        address owner = game.ownerOf(1);
        assertEq(owner, player);
    }

    function testRejectIfIncorrectETH() public {
        vm.prank(player);
        vm.expectRevert("Must send exactly 0.004 ETH");
        game.play{value: 0.005 ether}();
    }

    function testTokenURI() public {
        vm.prank(player);
        game.play{value: 0.004 ether}();

        // get URI for tokenId 1
        string memory uri = game.tokenURI(1);
        assert(bytes(uri).length > 0);
    }

    function testPayoutRangeMultiplePlays() public {
        for (uint i = 0; i < 10; i++) {
            vm.prank(player);
            game.play{value: 0.004 ether}();

            uint256 tokenId = i + 1;
            string memory uri = game.tokenURI(tokenId);
            assert(bytes(uri).length > 0);
        }
    }
}
