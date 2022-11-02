// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe{
    using Converter for uint256;
    uint256 public constant minimumusd = 50 * 1e18;

    mapping(address => uint256) public AddressToAmountFunded;
    
    address[] public funders;
    address public i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function Fund() public payable{
        require(msg.value.getConversionRate() >= minimumusd,"Didn't send enough!");
        funders.push(msg.sender);
        AddressToAmountFunded[msg.sender] += msg.value;
    }

        modifier onlyOwner {
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }

    function Withdraw() public onlyOwner{
        for(uint256 funderindex = 0 ; funderindex < funders.length ; funderindex++){
        address funder = funders[funderindex];
        AddressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        //transfer
        //payable(msg.sender).transfer(address(this).balance);
        //send
        //bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //require (sendSuccess, "send failed");
        //call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require (callSuccess, "call failed");

    }
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()
        
    
    fallback() external payable {
        Fund();
    }

    receive() external payable {
        Fund();
    }

}
