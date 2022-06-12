// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

error NotOwner(); // solidity ^0.8.7

contract FundMe {
    using PriceConverter for uint256;
    // uint256 public number;

    uint256 public constant minimumUsd = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    // test:
    // (minimumUsd)
    // get eth price from data.chain.link (ethprice)
    // minimumUsd / ethprice = (value in eth)
    // go to eth-converter.com to convert eth to wei then input to value field then press "fund"
    function fund() public payable {
        // want to be able to set a minimu fund amount in USD
        // 1. How do we send ETH to this contract?
        // number = 5;
        require(msg.value.getConversionRate() >= minimumUsd, "Didn't send enough"); //1e18wei = 1eth
        // require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough"); //1e18wei = 1eth
        // a ton of computation here
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;

        // what is reverting?
        // undo any action before, and send remaining gas back

    }

    function getPrice() public view returns(uint256) {
        // ABI
        // Address: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e (find on docs.chain.link)
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int price,,,) = priceFeed.latestRoundData();
        // ETH in terms of USD
        // 3000_0000000
        return uint256(price * 1e10); // 1**10 = 10000000000
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
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
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the array
        funders = new address[](0);
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
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner {
        // require(msg.sender == i_owner, "Sender is not owner!");
        if (msg.sender != i_owner) { revert NotOwner(); }
        _;
    }

    // What happens if someone sends this contract ETH without calling the fund function?
    receive() external payable {
        fund();
    }
    fallback() external payable {
        fund();
    }
}

// 1. Enums
// 2. Events
// 3. Try / Catch
// 4. Function Selectors
// 5. abi.encode / decode
// 6. Hashing
// 7. Yul / Assumbly
