// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownable {
    address public owner = msg.sender;
    address payable public teamCollector = payable(msg.sender);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(owner == msg.sender, "Ownable: Only owner");
        _;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        owner = newOwner;
        emit OwnershipTransferred(msg.sender, owner);
    }

    function setTeamCollector(address payable newTeamCollector) external onlyOwner {
        teamCollector = newTeamCollector;
    }
}