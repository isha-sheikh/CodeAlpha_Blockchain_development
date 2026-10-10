// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiSend {

/// @notice Sends equal amounts of Ether to multiple recipient addresses
/// @param recipients Array of payable Ethereum addresses
function sendEqual(address payable[] calldata recipients) external payable {
uint256 totalRecipients = recipients.length;
require(totalRecipients > 0, "No recipients provided");
require(msg.value > 0, "Must send Ether");

// Calculate equal share per address
uint256 amountPerRecipient = msg.value / totalRecipients;
require(amountPerRecipient > 0, "Amount per recipient too small");

// Loop and transfer Ether to each address
for (uint256 i = 0; i < totalRecipients; i++) {
(bool success, ) = recipients[i].call{value: amountPerRecipient}("");
require(success, "Transfer failed to recipient");
}

// Refund any remaining change back to sender
uint256 remainder = msg.value % totalRecipients;
if (remainder > 0) {
(bool refundSuccess, ) = msg.sender.call{value: remainder}("");
require(refundSuccess, "Refund failed");
}
}
}
