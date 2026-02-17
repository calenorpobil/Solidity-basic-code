// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

//ConsoleTest.t.sol

import "forge-std/Test.sol";

contract ConsoleTest is Test {
    function testLog() public pure {
        console.logString("Log desde prueba");
    }

    //Prueba de error
}
