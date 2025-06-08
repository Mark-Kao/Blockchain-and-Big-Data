// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DiceGame {
    string public name = "DiceGameNFT";
    string public symbol = "DGNFT";
    uint256 public nextTokenId;
    address public owner;

    uint256 public constant BET_AMOUNT = 0.004 ether;
    uint256 public minimumReserve = 0.01 ether;

    // Mapping: tokenId -> owner
    mapping(uint256 => address) private _owners;

    // Mapping: tokenId -> dice result
    mapping(uint256 => uint8) public tokenResult;

    // Mapping: result (1-6) to base URI for metadata
    mapping(uint8 => string) public resultToURI;

    event DiceRolled(
        address indexed player,
        uint8 result,
        uint256 payout,
        uint256 tokenId
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        nextTokenId = 1;

        // Set placeholder URIs for each dice face result (can replace with real URIs later)
        resultToURI[1] = "ipfs://dice-face-1";
        resultToURI[2] = "ipfs://dice-face-2";
        resultToURI[3] = "ipfs://dice-face-3";
        resultToURI[4] = "ipfs://dice-face-4";
        resultToURI[5] = "ipfs://dice-face-5";
        resultToURI[6] = "ipfs://dice-face-6";
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
                abi.encodePacked(block.timestamp, msg.sender, nextTokenId)
            )
        );
        return uint8((randomHash % 6) + 1);
    }

    function _mintNFT(address to, uint8 result) internal returns (uint256) {
        uint256 tokenId = nextTokenId;
        _owners[tokenId] = to;
        tokenResult[tokenId] = result;
        nextTokenId++;
        return tokenId;
    }

    function ownerOf(uint256 tokenId) external view returns (address) {
        address tokenOwner = _owners[tokenId];
        require(tokenOwner != address(0), "Token does not exist");
        return tokenOwner;
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_owners[tokenId] != address(0), "Token does not exist");
        uint8 result = tokenResult[tokenId];
        return resultToURI[result];
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

    function withdraw(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");
        payable(owner).transfer(amount);
    }

    receive() external payable {}

    fallback() external payable {}
}
