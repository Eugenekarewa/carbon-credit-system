// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title CarbonCreditToken
 * @dev ERC20 Token representing carbon credits
 */
contract CarbonCreditToken is ERC20 {
    address public admin;

    constructor() ERC20("CarbonCreditToken", "CCT") {
        admin = msg.sender;
    }

    /**
     * @dev Mint new tokens (admin-only function)
     * @param to Address to receive the tokens
     * @param amount Amount of tokens to mint
     */
    function mint(address to, uint256 amount) external {
        require(msg.sender == admin, "Only admin can mint");
        _mint(to, amount);
    }
}

/**
 * @title Marketplace
 * @dev Contract for buying, selling, and trading carbon credits
 */
contract Marketplace {
    struct Listing {
        address seller;
        uint256 amount;
        uint256 price; // Price per token in wei
    }

    uint256 public listingId;
    mapping(uint256 => Listing) public listings;
    CarbonCreditToken public token;

    /**
     * @dev Constructor to set the CarbonCreditToken contract address
     * @param tokenAddress Address of the CarbonCreditToken contract
     */
    constructor(address tokenAddress) {
        token = CarbonCreditToken(tokenAddress);
    }

    /**
     * @dev Create a new listing for selling carbon credits
     * @param amount Number of tokens to sell
     * @param price Price per token in wei
     */
    function createListing(uint256 amount, uint256 price) external {
        require(token.balanceOf(msg.sender) >= amount, "Insufficient token balance");
        require(token.allowance(msg.sender, address(this)) >= amount, "Approve tokens first");

        // Transfer tokens to the marketplace contract
        token.transferFrom(msg.sender, address(this), amount);

        // Create a new listing
        listings[listingId] = Listing(msg.sender, amount, price);
        listingId++;
    }

    /**
     * @dev Buy carbon credits from a listing
     * @param id ID of the listing to buy from
     */
    function buy(uint256 id) external payable {
        Listing storage listing = listings[id];
        require(msg.value >= listing.price * listing.amount, "Insufficient Ether sent");

        // Transfer tokens to the buyer
        token.transfer(msg.sender, listing.amount);

        // Transfer Ether to the seller
        payable(listing.seller).transfer(msg.value);

        // Remove the listing
        delete listings[id];
    }
}
