// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// This is the contract declaration, similar to a 'class'
contract SimpleStorage {

    // 1. State Variables (The Data)
    uint256 private favoriteNumber;
    address public owner;

    // 2. Constructor (The Initializer)
    // This runs ONCE, when the contract is deployed
    constructor() {
        owner = msg.sender;
    }

    // 3. Modifier (The Check)
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _; // This special symbol means "run the function code"
    }

    // 4. Functions (The Logic)
    
    /**
     * @notice Stores a new number, but only the owner can call it.
     * @param _newNumber The number to store
     */
    function storeNumber(uint256 _newNumber) public onlyOwner {
        favoriteNumber = _newNumber;
    }

    /**
     * @notice Retrieves the stored number.
     * @return The currently stored number
     */
    function retrieveNumber() public view returns (uint256) {
        return favoriteNumber;
    }
}