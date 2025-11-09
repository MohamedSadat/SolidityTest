// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;
// Import ERC20 standard from OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract ComContract is ERC20, Ownable,ReentrancyGuard 
{
 bool public paused;
 
    mapping(address=>uint)public balances;
mapping(address => bool) private _blacklist;
  mapping(address => uint256) public avaxBalances;

   uint256 public transferFeePercent = 1; // 1%
    address public feeCollector;

event FallbackCalled(address sender, uint amount, bytes data);
event Deposit(address indexed sender, uint amount);
event Withdraw(address indexed sender, uint amount);
event BlacklistUpdated(address indexed account, bool blacklisted);

    event NativeDeposited(address indexed user, uint256 amount);
    event NativeWithdrawn(address indexed user, uint256 amount);
    event TokenDeposited(address indexed user, address indexed token, uint256 amount);
    event TokenWithdrawn(address indexed user, address indexed token, uint256 amount);


    mapping(address => mapping(address => uint256)) public tokenBalances;

fallback() external payable { 
    emit FallbackCalled(msg.sender, msg.value, msg.data);
}

   // Handles plain Ether transfers (like bank deposits)
    receive() external payable {
        avaxBalances[msg.sender] += msg.value;
       emit NativeDeposited(msg.sender, msg.value);

    }
  function depositNative() public payable {
        require(msg.value > 0, "Must send AVAX");
        avaxBalances[msg.sender] += msg.value;
        emit NativeDeposited(msg.sender, msg.value);
    }
     // ✅ ADD THIS: Withdraw received AVAX
         function withdrawNative(uint256 amount) public nonReentrant {
        require(avaxBalances[msg.sender] >= amount, "Insufficient balance");
        avaxBalances[msg.sender] -= amount;
        
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
        
        emit NativeWithdrawn(msg.sender, amount);
    }
 
     function depositToken(address token, uint256 amount) public {
        require(amount > 0, "Amount must be > 0");
        
        // Transfer tokens from user to vault
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        
        tokenBalances[msg.sender][token] += amount;
        emit TokenDeposited(msg.sender, token, amount);
    }
    
    function withdrawToken(address token, uint256 amount) public nonReentrant {
        require(tokenBalances[msg.sender][token] >= amount, "Insufficient balance");
        tokenBalances[msg.sender][token] -= amount;
        
        IERC20(token).transfer(msg.sender, amount);
        emit TokenWithdrawn(msg.sender, token, amount);
    }
constructor(uint256 initialSupply)   ERC20("CashGear Token", "CGE")
        Ownable(msg.sender) // Initialize owner
        {
          _mint(msg.sender,initialSupply * 10 ** decimals());
          paused=false;
          feeCollector = msg.sender;

}

  function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount * 10 ** decimals());
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
     
    }


    function setPaused(bool _paused) public onlyOwner {
        paused = _paused;
    }
       // Override transfer to check if paused
 function _update(address from, address to, uint256 amount) internal virtual override {
    require(!_blacklist[from], "Sender is blacklisted");
    require(!_blacklist[to], "Recipient is blacklisted");
    require(!paused, "Transfers are paused");

    if (from != address(0) && to != address(0) && from != feeCollector && to != feeCollector) {
        uint256 fee = (amount * transferFeePercent) / 100;
        uint256 amountAfterFee = amount - fee;
        
        // Update balances directly, then call super ONCE
        super._update(from, to, amountAfterFee);
        super._update(from, feeCollector, fee);
    } else {
        super._update(from, to, amount);
    }
}
    function addToBlacklist(address account) public onlyOwner {
        require(account != address(0), "Cannot blacklist zero address");
        require(!_blacklist[account], "Address already blacklisted");
        
        _blacklist[account] = true;
        emit BlacklistUpdated(account, true);
    }
function removeFromBlacklist(address account) public onlyOwner {
     require(_blacklist[account], "Address not blacklisted");
        
        _blacklist[account] = false;
        emit BlacklistUpdated(account, false);
}

// Check if address is blacklisted (useful for UI)
function isBlacklisted(address account) public view returns (bool) {
    return _blacklist[account];
}

 function addMultipleToBlacklist(address[] calldata accounts) public onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            if (!_blacklist[accounts[i]] && accounts[i] != address(0)) {
                _blacklist[accounts[i]] = true;
                emit BlacklistUpdated(accounts[i], true);
            }
        }
    }
    
    function removeMultipleFromBlacklist(address[] calldata accounts) public onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            if (_blacklist[accounts[i]]) {
                _blacklist[accounts[i]] = false;
                emit BlacklistUpdated(accounts[i], false);
            }
        }
    }
}