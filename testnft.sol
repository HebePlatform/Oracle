// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./StdReferenceBasic.sol";

contract MyNFT is ERC721Enumerable, Ownable {
    address public referenceContractAddress;
    uint256 public mintPrice;

    constructor(address _referenceContractAddress, uint256 _mintPrice) ERC721("MyNFT", "NFT") {
        referenceContractAddress = _referenceContractAddress;
        mintPrice = _mintPrice;
    }

    function setReferenceContractAddress(address _newAddress) external onlyOwner {
        referenceContractAddress = _newAddress;
    }

    function getTokenPrice(string memory base, string memory quote) internal view returns (uint256) {
        StdReferenceBasic referenceContract = StdReferenceBasic(referenceContractAddress);
        StdReferenceBasic.ReferenceData memory data = referenceContract.getReferenceData(base, quote);
        return data.rate;
    }
    function getPrice() public view returns (uint256) {
        uint256 price = getTokenPrice("ETC", "USDT");
        return mintPrice * (10**18) / price; // Calculate the NFT price in Wei
    }

    function getPriceEtc() public view returns (uint256) {
        uint256 price = getTokenPrice("ETC", "USDT");
        return  price;
    }

    function setMintPrice(uint256 _newMintPrice) external onlyOwner {
        mintPrice = _newMintPrice;
    }



    function mint(address _to, uint256 _tokenId) external payable virtual {
        uint256 _amount = getPrice();
        require(msg.value == _amount, "005---msg.value error");
        _mint(_to, _tokenId);
    }
}
