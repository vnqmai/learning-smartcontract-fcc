// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// Pragma
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Import
// import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

// Error codes
error FundMe__NotOwner(); // solidity ^0.8.7

// Interfaces, libraries, contracts

/** @title A contract for crowd funding
 *   @author Mai VNQ
 *   @notice  This contract is to demo a sample funding contract
 *   @dev This implements price feeds as our library
 */
contract FundMe {
  // Type declarations
  using PriceConverter for uint256;
  // uint256 public number;

  // State variables
  uint256 public constant minimumUsd = 50 * 1e18;
  mapping(address => uint256) private s_addressToAmountFunded;
  address[] private s_funders;
  address private immutable i_owner;
  AggregatorV3Interface private s_priceFeed;

  // Modifiers
  modifier onlyOwner() {
    // require(msg.sender == i_owner, "Sender is not owner!");
    if (msg.sender != i_owner) {
      revert FundMe__NotOwner();
    }
    _;
  }

  // Functions Order:
  // constructor
  // receive
  // fallback
  // external
  // public
  // internal
  // private
  // view / pure

  constructor(address s_priceFeedAddress) {
    i_owner = msg.sender;
    s_priceFeed = AggregatorV3Interface(s_priceFeedAddress);
  }

  // // What happens if someone sends this contract ETH without calling the fund function?
  // receive() external payable {
  //   fund();
  // }

  // fallback() external payable {
  //   fund();
  // }

  // test:
  // (minimumUsd)
  // get eth price from data.chain.link (ethprice)
  // minimumUsd / ethprice = (value in eth)
  // go to eth-converter.com to convert eth to wei then input to value field then press "fund"
  /**
   * @notice This function funds this contract
   * @dev This implements price feeds as our library
   */
  function fund() public payable {
    // want to be able to set a minimu fund amount in USD
    // 1. How do we send ETH to this contract?
    // number = 5;
    require(
      msg.value.getConversionRate(s_priceFeed) >= minimumUsd,
      "Didn't send enough"
    ); //1e18wei = 1eth
    // require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough"); //1e18wei = 1eth
    // a ton of computation here
    s_funders.push(msg.sender);
    s_addressToAmountFunded[msg.sender] = msg.value;

    // what is reverting?
    // undo any action before, and send remaining gas back
  }

  function getPrice() public view returns (uint256) {
    // // ABI
    // // Address: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e (find on docs.chain.link)
    // AggregatorV3Interface s_priceFeed = AggregatorV3Interface(
    //   0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
    // );
    (, int256 price, , , ) = s_priceFeed.latestRoundData();
    // ETH in terms of USD
    // 3000_0000000
    return uint256(price * 1e10); // 1**10 = 10000000000
  }

  function getVersion() public view returns (uint256) {
    // AggregatorV3Interface s_priceFeed = AggregatorV3Interface(
    //   0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
    // );
    return s_priceFeed.version();
  }

  function getConversionRate(uint256 ethAmount) public view returns (uint256) {
    uint256 ethPrice = getPrice();
    uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; // Always multiple before you divide
    return ethAmountInUsd;

    // ex:
    // ethPrice = 3000_000000000000000000 = ETH / USD price
    // ethAmount = 1_000000000000000000
    // ethAmountInUsd = 2999.9999999999999999999999
  }

  function widthdraw() public onlyOwner {
    // require(msg.sender == owner, "Sender is not owner!");
    // for loop
    // [1, 2, 3, 4]
    // for (/* string index, ending index, step amount*/)
    for (
      uint256 funderIndex = 0;
      funderIndex < s_funders.length;
      funderIndex++
    ) {
      address funder = s_funders[funderIndex];
      s_addressToAmountFunded[funder] = 0;
    }
    // reset the array
    s_funders = new address[](0);
    // actually widthdraw the

    // // https://solidity-by-example.org/sending-ether/
    // // transfer
    // // msg.sender = address
    // // payable(msg.sender) = payable address
    // payable(msg.sender).transfer(address(this).balance);

    // // send
    // bool sendSuccess = payable(msg.sender).send(address(this).balance);
    // require(sendSuccess, "Send failed");

    // call - most recommended way to send token
    // *For the most part*
    // It can be case-by-case
    // (bool callSuccess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("");
    (bool callSuccess, ) = payable(msg.sender).call{
      value: address(this).balance
    }("");
    require(callSuccess, "Call failed");
  }

  function cheaperWithdraw() public payable onlyOwner {
    address[] memory funders = s_funders;
    // mappings can't be in memory, sorry!
    for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
      address funder = funders[funderIndex];
      s_addressToAmountFunded[funder] = 0;
    }
    s_funders = new address[](0);
    (bool success, ) = payable(i_owner).call{value: address(this).balance}("");
    require(success);
  }

  // View, pure

  function getOwner() public view returns (address) {
    return i_owner;
  }

  function getFunder(uint256 index) public view returns (address) {
    return s_funders[index];
  }

  function getAddressToAmountFunded(address funder)
    public
    view
    returns (uint256)
  {
    return s_addressToAmountFunded[funder];
  }

  function getPriceFeed() public view returns (AggregatorV3Interface) {
    return s_priceFeed;
  }
}

// 1. Enums
// 2. Events
// 3. Try / Catch
// 4. Function Selectors
// 5. abi.encode / decode
// 6. Hashing
// 7. Yul / Assumbly
