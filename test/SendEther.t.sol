// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {SendEther} from "../src/SendEther.sol";
import "forge-std/console.sol";

contract SendEtherTest is Test {
    SendEther public sendEther;

    function setUp() public {
        sendEther = new SendEther();
    }

    function _send(uint256 amount) public {
        (bool ok,) = address(sendEther).call{value: amount}("");
        require(ok, "send ETH failed");
    }

    function testEthBalance() public view {
        console.log("ETH Balance", address(this).balance / 1e18);
    }

    function testSendEther() public {
        uint256 bal = address(sendEther).balance;

        deal(address(1), 100);
        assertEq(address(1).balance, 100);

        //igual que hoax
        deal(address(1), 145); //"tienes 145 ETH"
        vm.prank(address(1)); //"eres el owner"
        _send(140); //"manda 140 ETH"

        //hoax
        hoax(address(1), 145);
        _send(140); //"manda 140 ETH"

        //Comprobación de que han llegado los ETH bien:
        assertEq(address(sendEther).balance, bal + 140 + 140);
    }
}
