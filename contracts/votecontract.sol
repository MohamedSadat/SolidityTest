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


     function reset() public onlyOwner {
        candidate1 = 0;
        candidate2 = 0;
        candidate3 = 0;

    }

        function voteFirst() public
         {
        candidate1++;
         }
    function voteSecond() public
         {
        candidate2++;
         }
         function voteThird() public
         {
        candidate3++;
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
    function getWinner() public view returns (string memory) {
        uint256 c1 = candidate1;
        uint256 c2 = candidate2;
        uint256 c3 = candidate3;

        // Check for Candidate 1 being the winner
        if (c1 > c2 && c1 > c3) {
            return "Candidate 1";
        } 
        // Check for Candidate 2 being the winner
        else if (c2 > c1 && c2 > c3) {
            return "Candidate 2";
        } 
        // Check for Candidate 3 being the winner
        else if (c3 > c1 && c3 > c2) {
            return "Candidate 3";
        } 
        // Check for a three-way tie
        else if (c1 == c2 && c2 == c3) {
            return "Three-way Tie!";
        } 
        // Check for a two-way tie
        else if (c1 == c2) {
            return "Tie between Candidate 1 and Candidate 2";
        }
        else if (c1 == c3) {
            return "Tie between Candidate 1 and Candidate 3";
        }
        else if (c2 == c3) {
            return "Tie between Candidate 2 and Candidate 3";
        } 
        // Fallback for an unhandled scenario (shouldn't happen with the logic above)
        else {
            return "No clear winner determined.";
        }
    }
}