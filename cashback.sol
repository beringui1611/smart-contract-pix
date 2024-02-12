// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CashBack is ERC20 {

    address private immutable owner;
    uint256 public  rewardPerBuy = 10000;
    address private  exchange;

    constructor()ERC20("Ze da cripto", "ZCN"){
         owner = msg.sender;
        _mint(msg.sender, 1000 *10 **decimals());

    }

    event TokensMinted(address indexed recipient, uint256 amount);


    function decimals() public  pure override  returns(uint8){
        return 8;
    }

    function setExchange(address _exchange) external {
        require(owner == msg.sender, "Only the owner can make this call");
        exchange = _exchange;
    }

    function mint(address customer) external onlyExchange {
        _mint(customer, rewardPerBuy);
        emit TokensMinted(msg.sender, rewardPerBuy);
    }

    modifier onlyExchange(){
        require(msg.sender == exchange, "Unauthorized!");
        _;
    }
}