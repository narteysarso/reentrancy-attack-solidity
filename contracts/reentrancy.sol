//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Reentrancy{

    mapping (address => uint) balanceOf;

    ///@dev send amount before updating balance. This opens the contract to a rentrancy attack
    function withdraw() external {
        require(balanceOf[msg.sender] > 0 , "Not enough amount");

        (bool sent, ) = msg.sender.call{value: balanceOf[msg.sender]}("");
        require(sent, "Failed to send amount");

        balanceOf[msg.sender] = 0;
    }

    function deposit() external  payable {
        require(msg.value > 0, "Amount not enough");

        balanceOf[msg.sender] += msg.value;
    }

    receive() payable external {}
    fallback() payable external{}

}