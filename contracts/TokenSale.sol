// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./Ownable.sol";
import "./SafeMath.sol";
import "./TokenSaleProxy.sol";
import "./TokenSaleInfo.sol";

contract TokenSale is Ownable {
    event PurchasedToken(
        uint saleId,
        IERC20 token
    );

    event TokenSaleCreated(
        uint saleId,
        address proxy,
        IERC20 token
    );

    using SafeMath for uint256;

    TokenSaleInfo[] private _info;

    function getTokenSaleInfo(uint saleId) public view returns (TokenSaleInfo memory) {
        return _info[saleId];
    }

    function addTokenSaleNow(
        uint _price, 
        IERC20 _token, 
        address payable _collector,
        uint _endVia
    ) public returns (uint index, address proxyAddr) {
        return addTokenSale(block.timestamp, block.timestamp + _endVia, _price, _token, _collector);
    }

    function addTokenSale(
        uint _startTime, 
        uint _endTime, 
        uint _price, 
        IERC20 _token, 
        address payable _collector
    ) public returns (uint index, address proxyAddr) {
            
        _info.push(TokenSaleInfo(
            _startTime,
            _endTime,
            _price,
            _token,
            _collector,
            msg.sender
        ));
        index = _info.length - 1;

        TokenSaleProxy tsp = new TokenSaleProxy(index, address(this));
        proxyAddr = address(tsp);
        emit TokenSaleCreated(index, proxyAddr, _token);
    }

    function buyToken(uint saleId, address recipient) payable external {
        require(block.timestamp > _info[saleId].startTime, "TokenSale: SALE_NOT_STARTED");
        require(block.timestamp < _info[saleId].endTime, "TokenSale: SALE_END");

        uint256 tokens = msg.value;
        tokens = tokens.mul(_info[saleId].price);
        tokens = tokens.div(10**(18 - _info[saleId].token.decimals()));

        _info[saleId].token.transfer(recipient, tokens);

        uint amount = msg.value;
        amount = amount.sub(amount.div(100));

        _info[saleId].collector.transfer(amount);
        teamCollector.transfer(address(this).balance);

        emit PurchasedToken(saleId, _info[saleId].token);
    }

    function withdrawToken(uint saleId, uint256 amount, address recipient) external {
        require(_info[saleId].creator == msg.sender, "TokenSale: NOT_CREATOR");
        require(_info[saleId].token.balanceOf(address(this)) >= amount, "TokenSale: INSUFFICIENT_BALANCE");

        _info[saleId].token.transfer(recipient, amount);
    }
}