// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyToken {
    mapping(address => uint256) public balances;
    address public owner;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 amount);

    // Modifier
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner!");
        _;
    }

    // Constructor
    constructor() {
        owner = msg.sender;
    }

    // Mint tokens (owner only)
    function mint(address to, uint256 amount) public onlyOwner {
        balances[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    // Transfer tokens
    function transfer(address to, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    // Burn tokens (owner only)
    function burn(address from, uint256 amount) public onlyOwner {
        require(balances[from] >= amount, "Insufficient balance to burn");
        balances[from] -= amount;
        emit Transfer(from, address(0), amount);
    }
}
