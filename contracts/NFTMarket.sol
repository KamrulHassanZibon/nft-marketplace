// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@oepnzeppelin/contracts/utils/Counters.sol";
import "@oepnzeppelin/contracts/token/ERC721/extention/ERC721URIStorage.sol";
import "@oepnzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplace is ERC721URIStorage {
using Counters for Counter.Counter;
Counters.Counter private _tokenIds; //total number of items ever created
Counters.Counter private _itemSold; //total number of items ever sold

uint256 lisingPrice = 0.001 ether; //people have to pay to list their nft on this market
address payable owner; //owner of the smart contract

constructor() ERC721("BlackPink","BPK"){
    owner = payable(msg.sender);
}

mapping (uint256 => MarketItem) private idToMarketItem;

struct MarketItem{ 
    uint256 tokenId;
    address payable seller;
    address payable owner;
    uint256 price;
    bool sold;
}

event MarketItemCreated (
    uint256 tokenId;
    address seller;
    address owner;
    uint256 price;
    bool sold
);

}

