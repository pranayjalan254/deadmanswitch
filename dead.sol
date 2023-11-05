// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeadmanSwitch {
    address public owner;
    address public beneficiary;
    uint256 public lastBlock;

    constructor(address _beneficiary) payable {
        owner = msg.sender;
        beneficiary = _beneficiary;
        lastBlock = block.number;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner have the access of this function");
        _;
    }

    function still_alive() external onlyOwner {
        lastBlock = block.number;
    }

    function check() payable public {
        require(block.number - lastBlock > 10, "Owner has not called still_alive in the last 10 blocks");
        payable(beneficiary).transfer(address(this).balance);    
    }
    function send(uint value) payable external onlyOwner {
        payable (address(this)).transfer(value);
    }
    function withdraw(uint value) payable external onlyOwner {
        payable (owner).transfer(value);
    }

    receive() external payable { 
        // revert();
    }
    fallback() external payable { }
}