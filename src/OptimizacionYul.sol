// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract ContratoOptimizado {
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

    // 2 Unchecked Solidity
    function uncheckedSolidity() public pure {
        uint256 j = 0;
        for (uint256 i = 0; i < 10;) {
            j++;
            unchecked {
                ++i;
            }
        }
    }

    // 2 Unchecked YUL
    function uncheckedYul() public pure {
        assembly {
            let j := 0

            for {
                let i := 0
            } lt(i, 10) {
                i := add(i, 0x01)
            } {
                j := add(j, 0x01)
            }
        }
    }

    // 3 Operaciones matematicas YUL
    function operacionesMatematicasYul(uint256 a, uint256 b) public {
        // Restar
        assembly {
            let c := sub(a, b)

            // Verifica si ocurre desbordamiento negativo (underflow)
            if gt(c, a) {
                mstore(0x00, "Underflow detected")
                revert(0x00, 0x20) // Revertir si c es mayor que a
            }
        }
    }

    // 4 Almacenamiento de variables YUL

    address owner = 0x1234567890123456789012345678901234567890;

    function updateOwnerYUL(uint256 newValue) public {
        assembly {
            sstore(owner.slot, newValue)
        }
    }
}
