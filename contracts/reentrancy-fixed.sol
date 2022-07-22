//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract ReentrancyFixed{

    mapping (address => uint) balanceOf;

    ///@dev update balance before sending a amount
    /// This causes a reentrancy attack transaction to fail/revert. No amount is sent at all.
    function withdraw() external {
        require(balanceOf[msg.sender] > 0 , "Not enough amount");

        uint amount = balanceOf[msg.sender];

        balanceOf[msg.sender] = 0;


        (bool sent, ) = msg.sender.call{value: amount}("");

        require(sent, "Failed to send amount");
    }

    function deposit() external  payable {
        require(msg.value > 0, "Amount not enough");

        balanceOf[msg.sender] += msg.value;
    }

    receive() payable external {}
    fallback() payable external{}

}