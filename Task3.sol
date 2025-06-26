// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lending {
    address public owner;
    uint public interestRate = 5;

    mapping(address => uint) public deposits;
    mapping(address => uint) public borrowings;

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable {
        require(msg.value > 0, "Deposit must be > 0");
        deposits[msg.sender] += msg.value;
    }

    function borrow() external payable {
        uint borrowAmount = msg.value / 2;
        require(borrowAmount > 0, "Collateral too small");
        require(address(this).balance >= borrowAmount, "Insufficient liquidity");

        borrowings[msg.sender] += borrowAmount;
        payable(msg.sender).transfer(borrowAmount);
    }

    function repay() external payable {
        require(borrowings[msg.sender] > 0, "No loan");
        require(msg.value >= borrowings[msg.sender], "Repay full amount");

        borrowings[msg.sender] = 0;
    }

    function withdraw(uint amount) external {
        require(deposits[msg.sender] >= amount, "Insufficient balance");
        deposits[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function getPoolBalance() public view returns (uint) {
        return address(this).balance;
    }
}
