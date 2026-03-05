// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Contratotimizado {
    // Consumo: 949 gas
    function sum(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }

    // Optimizada: 748 gas
    function sumYul(uint256 a, uint256 b) public pure returns (uint256 result) {
        assembly {
            result := add(a, b)
        }
    }

    // 1 Funcion hash Solidity
    function solidityHash(uint256 a, uint256 b) public pure {
        keccak256(abi.encodePacked(a, b));
    }

    // Funcion hash YUL
    function yulHash(uint256 a, uint256 b) public pure {
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            let hash := keccak256(0x00, 0x40)
        }
    }
}
