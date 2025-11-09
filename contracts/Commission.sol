// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
// Import ERC20 standard from OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ComContract
{
event OwnershipTransfered(address indexed previousOwner,address indexed newOwner);
    address owner;
    mapping(address=>uint)public balances;

event FallbackCalled(address sender, uint amount, bytes data);
event ReceivedEther(address sender, uint amount);
event Deposit(address indexed sender, uint amount);
event Withdraw(address indexed sender, uint amount);
event MoneySent(address indexed sender, uint amount);

fallback() external payable { 
    emit FallbackCalled(msg.sender, msg.value, msg.data);
}

   // Handles plain Ether transfers (like bank deposits)
    receive() external payable {
        emit ReceivedEther(msg.sender, msg.value);
    }
constructor() {
    owner=msg.sender;
}

modifier onlyOwner()
{
    require(msg.sender == owner, "Not owner");
    _;
}


function TransferOwnership() public onlyOwner 
{
owner=msg.sender;
emit OwnershipTransfered(owner,msg.sender);
}

   function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function SendMoney(address _to, uint _amount) public onlyOwner {
        require(_to != address(0), "Invalid address");
        require(_amount > 0, "Amount must be greater than zero");
        payable(_to).transfer(_amount);
        emit MoneySent(_to, _amount);
    }

}