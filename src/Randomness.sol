// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract RandomnessVulnerable {
    uint private seed;
    uint public randomNumber;

    constructor() {
        seed = block.timestamp; //Establecemos el valor de la semilla
    }

    function generateRandomNumber() public {
        randomNumber = uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, seed)));
    }
}


//Modo seguro: 
interface RandomnessOracle {
    function getRandomNumber() external returns (uint);
}

contract RandomnessOptimizado {
    //Será una interfaz de un oráculo externo, que asegure la aleatoriedad. 
    uint256 public randomNumber;
    address private oracle; 

    constructor(address _oracleAddress) {
        oracle = _oracleAddress;
    }

    function generateRandomNumber() public {
        require(oracle != address(0), "Oracle address not set");

        randomNumber = RandomnessOracle(oracle).getRandomNumber();
    }
}