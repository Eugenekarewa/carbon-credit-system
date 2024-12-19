// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 private storedData;
    address private owner;

    // Modifier to restrict access
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner!");
        _;
    }

    // Constructor sets the deployer as the owner
    constructor() {
        owner = msg.sender;
    }

    // Function to store data (only owner can call)
    function set(uint256 _data) public onlyOwner {
        storedData = _data;
    }

    // Function to retrieve data
    function get() public view returns (uint256) {
        return storedData;
    }

    // Function to reset data (only owner can call)
    function reset() public onlyOwner {
        storedData = 0;
    }

    // Function to transfer ownership
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address!"); // Prevent assigning ownership to the zero address
        owner = newOwner;
    }

    // Function to check current owner
    function getOwner() public view returns (address) {
        return owner;
    }
}
