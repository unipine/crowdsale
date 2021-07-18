// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TokenSale.sol";
import "./TokenSaleInfo.sol";

contract TokenSaleProxy {
    TokenSale ts = TokenSale(msg.sender);
    uint saleId;

    constructor(uint _saleId, address _tokenSale) {
        ts = TokenSale(_tokenSale);
        saleId = _saleId;
    }

    receive() payable external {
        TokenSaleInfo memory tsi = ts.getTokenSaleInfo(saleId);
        uint256 balance = tsi.token.balanceOf(address(this));
        if(balance > 0) {
            tsi.token.transfer(address(ts), balance);
        }
        ts.buyToken{value: msg.value}(saleId, msg.sender);
    }
}