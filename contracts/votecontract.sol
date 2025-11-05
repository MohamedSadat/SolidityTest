// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// This is the contract declaration, similar to a 'class'
contract VotingSystem {

    // 1. State Variables (The Data)
    uint256 private favoriteNumber;
    uint256 private candidate1;
    uint256 private candidate2;
    uint256 private candidate3;

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
     function reset() public onlyOwner {
        candidate1 = 0;
        candidate2 = 0;
        candidate3 = 0;

    }

        function voteFirst(uint256 _newNumber) public
         {
        candidate1 = _newNumber;
         }
    function voteSecond(uint256 _newNumber) public
         {
        candidate2 = _newNumber;
         }
         function voteThird(uint256 _newNumber) public
         {
        candidate3 = _newNumber;
         }
         
    /**
     * @notice Retrieves the stored number.
     * @return The currently stored number
     */
    function retrieveFirst() public view returns (uint256) {
        return candidate1;
    }
        function retrieveSecond() public view returns (uint256) {
        return candidate2;
    }
        function retrieveThird() public view returns (uint256) {
        return candidate3;
    }
            function retrieveTotal() public view returns (uint256) {
        return candidate1+candidate2+candidate3;
    }
}