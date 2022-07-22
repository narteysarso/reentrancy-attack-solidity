//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract ReentrancyFixedLock{

    bool locked = false;

    modifier nonRentrant {
        //this causes a revert if locked is true
        require(!locked, "No re-entrancy");
        
        locked = true;
        
        _;

        locked = false;
    }

    mapping (address => uint) balanceOf;

    /// @dev This solution prevent reentrancy attack by preventing the execution of the function
    /// until locked is false. As such locked is set to true until the execution is finished.
    /// making sure the function executes fully before the next call to it is executed.
    /// This causes a reentrancy attack transaction to fail/revert. No amount is sent at all.
    function withdraw()  external nonRentrant {
        require(balanceOf[msg.sender] > 0 , "Not enough amount");

        uint amount = balanceOf[msg.sender];

        (bool sent, ) = msg.sender.call{value: amount}("");  

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