// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeMathTester {
    uint8 public bigNumber = 255; //solidity ver.0.6.0: unchecked, ver0.8.0: checked

    function add() public {
        unchecked {bigNumber = bigNumber + 1;}
    }
}
