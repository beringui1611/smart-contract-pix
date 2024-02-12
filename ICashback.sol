// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
interface ICashback is IERC20{

    function mint(address customer) external ;

}