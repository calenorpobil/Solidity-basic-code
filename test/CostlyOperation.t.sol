// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/CostlyOperation.sol";
import "forge-std/console2.sol";


contract CostlyOperationVulnerabilityTest is Test {
    CostlyOperationVulnerability public costlyOperationVulnerability;

    function setUp() public {
        costlyOperationVulnerability = new CostlyOperationVulnerability();
    }

    function test_addNumber() external {
        costlyOperationVulnerability.addNumber(10);
        costlyOperationVulnerability.addNumber(20);
        costlyOperationVulnerability.addNumber(30);
        
        assertEq(costlyOperationVulnerability.getLength(), 3);
    }

    function test_sumAll() external {
        // Add some numbers
        costlyOperationVulnerability.addNumber(10);
        costlyOperationVulnerability.addNumber(20);
        costlyOperationVulnerability.addNumber(30);
        
        // Check sum
        uint256 sum = costlyOperationVulnerability.sumAll();
        console2.log("Sum:", sum);
        assertEq(sum, 60);
    }

    function test_findNumber() external {
        // Add some numbers
        costlyOperationVulnerability.addNumber(10);
        costlyOperationVulnerability.addNumber(20);
        costlyOperationVulnerability.addNumber(30);
        
        // Find number
        uint256 index = costlyOperationVulnerability.findNumber(20);
        console2.log("Index of 20:", index);
        assertEq(index, 1);
    }
}


contract CostlyOperationOptimizadoTest is Test {
    CostlyOperationOptimizado public costlyOperationOptimizado;

    function setUp() public {
        costlyOperationOptimizado = new CostlyOperationOptimizado();
    }

    function test_addNumber() external {
        costlyOperationOptimizado.addNumber(10);
        costlyOperationOptimizado.addNumber(20);
        costlyOperationOptimizado.addNumber(30);
        
        assertEq(costlyOperationOptimizado.getLength(), 3);
    }

    function test_sumAll() external {
        // Add some numbers
        costlyOperationOptimizado.addNumber(10);
        costlyOperationOptimizado.addNumber(20);
        costlyOperationOptimizado.addNumber(30);
        
        // Check sum - O(1) operation
        uint256 sum = costlyOperationOptimizado.sumAll();
        console2.log("Sum:", sum);
        assertEq(sum, 60);
    }

    function test_findNumber() external {
        // Add some numbers
        costlyOperationOptimizado.addNumber(10);
        costlyOperationOptimizado.addNumber(20);
        costlyOperationOptimizado.addNumber(30);
        
        // Find number - O(1) operation using mapping
        uint256 index = costlyOperationOptimizado.findNumber(20);
        console2.log("Index of 20:", index);
        assertEq(index, 1);
    }
}