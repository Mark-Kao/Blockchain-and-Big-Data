// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DiceGame is ERC721URIStorage, Ownable {
    uint256 public nextTokenId;
    uint256 public constant BET_AMOUNT = 0.004 ether;
    uint256 public minimumReserve = 0.01 ether;

    mapping(uint256 => uint8) public tokenResult;
    mapping(uint8 => string) public resultToURI;

    event DiceRolled(
        address indexed player,
        uint8 result,
        uint256 payout,
        uint256 tokenId
    );

    constructor() ERC721("DiceGameNFT", "DGNFT") Ownable(msg.sender) {
        nextTokenId = 1;

        // Set placeholder URIs for each dice face result (can replace with real URIs later)
        resultToURI[1] = "ipfs://bafybeicqkx47pf55gibsn7hhcnlstgiw766mxgttjuiu6tizg3b5qihf5m/dice_1.json";
        resultToURI[2] = "ipfs://bafybeicqkx47pf55gibsn7hhcnlstgiw766mxgttjuiu6tizg3b5qihf5m/dice_2.json";
        resultToURI[3] = "ipfs://bafybeicqkx47pf55gibsn7hhcnlstgiw766mxgttjuiu6tizg3b5qihf5m/dice_3.json";
        resultToURI[4] = "ipfs://bafybeicqkx47pf55gibsn7hhcnlstgiw766mxgttjuiu6tizg3b5qihf5m/dice_4.json";
        resultToURI[5] = "ipfs://bafybeicqkx47pf55gibsn7hhcnlstgiw766mxgttjuiu6tizg3b5qihf5m/dice_5.json";
        resultToURI[6] = "ipfs://bafybeicqkx47pf55gibsn7hhcnlstgiw766mxgttjuiu6tizg3b5qihf5m/dice_6.json";
    }

    function play() external payable {
        require(msg.value == BET_AMOUNT, "Must send exactly 0.004 ETH");

        require(
            address(this).balance >= minimumReserve,
            "Contract balance too low"
        );

        uint8 result = randomDiceRoll();
        uint256 payout = result * 0.001 ether;

        // Pay prize
        payable(msg.sender).transfer(payout);

        // Mint NFT tied to result
        uint256 tokenId = _mintNFT(msg.sender, result);

        emit DiceRolled(msg.sender, result, payout, tokenId);
    }

    function randomDiceRoll() internal view returns (uint8) {
        uint256 randomHash = uint256(
            keccak256(
                abi.encodePacked(block.prevrandao, msg.sender, nextTokenId)
            )
        );
        return uint8((randomHash % 6) + 1);
    }

    function _mintNFT(address to, uint8 result) internal returns (uint256) {
        uint256 tokenId = nextTokenId;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, resultToURI[result]);
        tokenResult[tokenId] = result;
        nextTokenId++;
        return tokenId;
    }

    function setResultURI(
        uint8 result,
        string calldata uri
    ) external onlyOwner {
        require(result >= 1 && result <= 6, "Invalid result");
        resultToURI[result] = uri;
    }

    function setMinimumReserve(uint256 newReserve) external onlyOwner {
        minimumReserve = newReserve;
    }

    function withdrawAll() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    receive() external payable {}

    fallback() external payable {}
}
