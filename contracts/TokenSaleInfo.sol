// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

struct TokenSaleInfo {
    uint startTime;
    uint endTime;
    uint price;
    IERC20 token;
    address payable collector;
    address creator;
}