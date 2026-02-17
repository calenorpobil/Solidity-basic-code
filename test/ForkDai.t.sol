// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import "./interfaces/IERC20.sol";


contract ForkDaiTest is Test {
    IERC20 public dai;

    function setUp() public {
        //Esta dirección es la de DAI:
        dai = IERC20(address(0x6B175474E89094C44Da98b954EedeAC495271d0F)); 
    }

    function testAddress() public view {        
        //Para conseguir la dirección del contrato: 
        console.log(address(this));         
    }

    function testDeposit() public {        
        address andrea = address(123);

        uint256 balanceInicial = dai.balanceOf(andrea);
        console.log("Balance inicial:", balanceInicial / 1e18);

        uint256 totalInicial = dai.totalSupply();
        console.log("Total inicial:", totalInicial / 1e18);

        deal(address(dai), andrea, 1e6 * 1e18, true);

        uint256 balanceFinal = dai.balanceOf(andrea);
        console.log("Balance final:", balanceFinal / 1e18);

        uint256 totalFinal = dai.totalSupply();
        console.log("Total final:", totalFinal / 1e18);
    }

}

// Alchemy API Key: I3zuEBuwYBz_y6vpwuchC

// forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/I3zuEBuwYBz_y6vpwuchC --match-path test/ForkDai.t.sol  -vvvv
// forge test --etherscan-api-key I3zuEBuwYBz_y6vpwuchC --match-path test/SendEther.t.sol  -vvvv

