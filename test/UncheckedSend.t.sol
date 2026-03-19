// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/UncheckedSend.sol";

contract UncheckedSendVulnerabilityTest is Test {
    UncheckedSendVulnerability public uncheckedSendVulnerability;

    function setUp() public {
        uncheckedSendVulnerability = new UncheckedSendVulnerability();
        // Give this test contract some ETH for testing
        vm.deal(address(this), 100 ether);
    }

    // Required to receive ETH when withdraw is called
    receive() external payable {}

    function test_deposit() external {
        uncheckedSendVulnerability.deposit{value: 1 ether}();
    }

    function test_withdraw() external {
        // Log initial balance
        console2.log("Balance:", uncheckedSendVulnerability.getBalance());

        // First deposit some ETH to have a balance
        uncheckedSendVulnerability.deposit{value: 10 ether}();
        console2.log("Balance:", uncheckedSendVulnerability.getBalance());

        // Then withdraw
        uncheckedSendVulnerability.withdraw(1 ether);
        console2.log("Balance:", uncheckedSendVulnerability.getBalance());
    }
}

contract UncheckedSendOptimizadoTest is Test {
    UncheckedSendOptimizado public uncheckedSendOptimizado;

    function setUp() public {
        uncheckedSendOptimizado = new UncheckedSendOptimizado();
        // Give this test contract some ETH for testing
        vm.deal(address(this), 1.01 ether);
    }

    // Required to receive ETH when withdraw is called
    receive() external payable {}

    function test_deposit() external {
        uncheckedSendOptimizado.deposit{value: 1.01 ether}();
    }

    function test_withdraw() external {
        // First deposit some ETH to have a balance
        uncheckedSendOptimizado.deposit{value: 1.01 ether}();
        console2.log("Balance:", uncheckedSendOptimizado.getBalance());

        // Then withdraw
        uncheckedSendOptimizado.withdraw(1.01 ether);
        console2.log("Balance:", uncheckedSendOptimizado.getBalance());
    }
}
