// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import ERC20 standard from OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title CashGear Token (CGE)
/// @notice Example ERC20 token contract
/// @dev Uses OpenZeppelin ERC20 + Ownable
contract CashGearToken is ERC20, Ownable {
    /// @notice Constructor: mint initial supply to deployer
    /// @param initialSupply The total number of tokens to mint (in smallest units)
    constructor(uint256 initialSupply)
        ERC20("CashGear Token", "CGE")
        Ownable(msg.sender) // Initialize owner
    {
        // Mint the initial supply to the deployer
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }

    /// @notice Mint new tokens (only owner)
    /// @param to The recipient address
    /// @param amount The number of tokens to mint
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * 10 ** decimals());
    }

    /// @notice Burn tokens from sender’s balance
    /// @param amount Number of tokens to burn
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
}
