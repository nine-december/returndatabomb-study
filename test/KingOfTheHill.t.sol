// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {TestHarness} from "./utils/TestHarness.sol";
import "../src/KingOfTheHill.sol";

contract TestKingOfTheHill is TestHarness {
    KingOfTheHill hill;
    EvilKing evilKing;

    function setUp() external {
        hill = new KingOfTheHill();
        evilKing = new EvilKing(hill);
    }

    function test_doBombedBid() external {
        evilKing.doBombedBid{value: 1 ether}();

        hill.bombedBid{value: 2 ether, gas: 100000}();
    }

    function test_doMethodBidWithReturn() external {
        evilKing.doMethodBidWithReturn{value: 1 ether}();

        hill.methodBidWithReturn{value: 2 ether, gas: 1_000_000}();
    }

    function test_doSafeBid() external {
        evilKing.doSafeBid{value: 1 ether}();

        hill.safeBid{value: 2 ether, gas: 500_000}();
    }
    
}