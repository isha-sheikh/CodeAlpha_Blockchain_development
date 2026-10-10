// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TimeLock {
address public beneficiary;
uint256 public releaseTime;

constructor(address _beneficiary, uint256 _releaseTime) payable {
require(_releaseTime > block.timestamp, "Release time must be in the future");
beneficiary = _beneficiary;
releaseTime = _releaseTime;
}

// Function to deposit more funds if needed
receive() external payable {}

// Function to release funds after the time lock expires
function release() public {
require(block.timestamp >= releaseTime, "Current time is before release time");
uint256 amount = address(this).balance;
require(amount > 0, "No ether to release");

(bool success, ) = beneficiary.call{value: amount}("");
require(success, "Transfer failed");
}
}