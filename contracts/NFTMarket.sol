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


//Getting Listing Price
function getListingPrice() public view returns(uint256){
    return listingPrice;
}

//Update Listing price
function updateListingPrice(uint _listingPrice) public payable{
    require(owner == msg.sender, "Only market maker can update price");
    listingPrice = _listingPrice;
}

//Create a market Item
function createMarketItem(uint256 tokenId, uint256 price) private {
require(price > 0, "Price Must be gretter then 0");
require(msg.value == listingPrice, "Price must be equal to listing price");

itToMarketItem[tokenId] = MarketItem(
    tokenId, 
    payable(msg.sender),
    payable(address(this)),
    price,
    false
);

_transfer(msg.sender, address(this), tokenId);
emit MarketItemCreated(tokenId, msg.sender, address(this), price, false);
}

//minting a new token and list it in marketplace

function createToken(string memory tokenURI, uint256 price) public payable returns(uint){
    _tokenIds.increment();
    uint256 newTokenId = _tokenIds.current();
    _mint(msg.sender, newTokenId);
    _setTokenURI(newTokenId, tokenURI);
    createMarketItem(newTokenId, price);
    return newTokenId;
}

//Crating the sale of a marketplace item
//Transfer ownership of the Item
function createMarketSale(uint256 tokenId) public payable {
    uint price = idToMarketItem[tokenId].price;
    address seller = idToMarketItem[tokenId].seller;

    require(msg.value == price, "Please sublit the asking price in order to make purchase");
    idToMarketItem[tokenId].owner = payable(msg.sender);
    idToMarketItem[tokenId].sold = true;
    idToMarketItem[tokenId].seller = payable(address(0));
    _itemSold.increment();
    _transfer(address(this), msg.sender, tokenId);
    payable(owner).transfer(listingPrice);
    payable(seller).transfer(msg.value);

}

}

