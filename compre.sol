// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ICashback.sol";

contract Exchange  {
    address private owner;
    mapping(address => uint) public tokenAddressAndBalance;
    mapping(address => uint) public presaleBalanceTokens;
    ICashback public cashback;

    constructor(address _cashback) {
        cashback = ICashback(_cashback);
        owner = msg.sender; 
    }    

    function deposit(address addressToken, uint amount) external {
        IERC20 token = IERC20(addressToken);
        require(token.allowance(msg.sender, address(this)) >= amount, "You need to approve this address first.");
        
        token.transferFrom(msg.sender, address(this), amount);
        tokenAddressAndBalance[addressToken] += amount;
    }

    function withdraw(address customer, address tokenAddress, uint amount) external onlyOwner {
        IERC20 token = IERC20(tokenAddress);
        require(token.balanceOf(address(this)) >= amount, "Insufficient funds.");
        token.transfer(customer, amount);
    }

    function buy(address to, address tokenAddress, uint amount) external onlyOwner {
        IERC20 token = IERC20(tokenAddress);
        require(token.transfer(to, amount), "Transfer failed!");
        tokenAddressAndBalance[tokenAddress] -= amount; // Deduct transferred amount from contract balance
        cashback.mint(to);
    }


    function presaleDeposit(address tokenAddress, uint amount) external {
        IERC20 tokenSale = IERC20(tokenAddress);
        require(tokenSale.allowance(msg.sender, address(this)) >= amount, "You need to approve this address first");
        tokenSale.transferFrom(msg.sender,address(this), amount);
        presaleBalanceTokens[tokenAddress] += amount;

    }

    function presaleSell(address to, address tokenAddress, uint amount) external {
        IERC20 tokenSell = IERC20(tokenAddress);
        uint price = amount * 10/ 100;
        require(tokenSell.transfer(owner, price));
        require(tokenSell.transfer(to, amount - price));
        presaleBalanceTokens[tokenAddress] -= amount;
        
    }


    modifier onlyOwner(){
        require(msg.sender == owner, "Unauthorized!");
        _;
    }
}
