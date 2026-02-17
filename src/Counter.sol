// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

//Console sólo está disponible para pruebas.
//Habrá que borrarlo cuando se implemente o despliegue.
import "forge-std/console.sol";

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
        console.log("Hola desde setNumber");
    }

    function increment() public {
        number++;
    }

    function decrement() public {
        number--;
    }
}
