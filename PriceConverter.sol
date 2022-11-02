// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library Converter{
        
    function getPrice() internal view returns(uint256) {
        // address 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        AggregatorV3Interface PriceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (,int256 price,,,) = PriceFeed.latestRoundData();
        return uint256(price * 1e18);
    }
    
    function getVersion() internal view returns(uint256){
        return AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e).version();
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256){

        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
