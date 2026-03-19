// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
//import {Fork} from "../src/Fork.sol";
import "forge-std/console.sol";

interface IWETH {
    function balanceOf(address) external view returns (uint256);
    function deposit() external payable;
}

contract ForkTest is Test {
    IWETH public weth;

    function setUp() public {
        weth = IWETH(address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2));
    }
/*
    function testDeposit() public {
        uint256 balanceInicial = weth.balanceOf(address(this));
        console.log("Balance inicial: ", balanceInicial);

        weth.deposit{value: 500}();

        uint256 balanceFinal = weth.balanceOf(address(this));
        console.log("Balance final: ", balanceFinal);
    }*/
}

// Alchemy API Key: I3zuEBuwYBz_y6vpwuchC

// forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/I3zuEBuwYBz_y6vpwuchC --match-path test/SendEther.t.sol  -vvvv
// forge test --etherscan-api-key I3zuEBuwYBz_y6vpwuchC --match-path test/SendEther.t.sol  -vvvv

