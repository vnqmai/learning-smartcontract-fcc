// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
  function getPrice(AggregatorV3Interface priceFeed)
    internal
    view
    returns (uint256)
  {
    // // ABI
    // // Address: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e (find on docs.chain.link)
    // AggregatorV3Interface priceFeed = AggregatorV3Interface(
    //   0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
    // );
    (, int256 price, , , ) = priceFeed.latestRoundData();
    // ETH in terms of USD
    // 3000_0000000
    return uint256(price * 1e10); // 1**10 = 10000000000
  }

  function getVersion(AggregatorV3Interface priceFeed)
    internal
    view
    returns (uint256)
  {
    // AggregatorV3Interface priceFeed = AggregatorV3Interface(
    //   0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
    // );
    return priceFeed.version();
  }

  function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed)
    internal
    view
    returns (uint256)
  {
    uint256 ethPrice = getPrice(priceFeed);
    uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; // Always multiple before you divide
    return ethAmountInUsd;

    // ex:
    // ethPrice = 3000_000000000000000000 = ETH / USD price
    // ethAmount = 1_000000000000000000
    // ethAmountInUsd = 2999.9999999999999999999999
  }
}
