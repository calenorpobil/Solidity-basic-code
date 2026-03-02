// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract CostlyOperationVulnerability {
    uint256[] private numbers;

    function addNumber(uint256 _num) external {
        numbers.push(_num);
    }

    // Vulnerabilidad: iterar sobre un array completo puede ser muy costoso
    // si el array crece demasiado, puede exceder el limite de gas
    function sumAll() external view returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 0; i < numbers.length; i++) {
            total += numbers[i];
        }
        return total;
    }

    // Vulnerabilidad: buscar en un array sin limite puede ser costoso
    function findNumber(uint256 _num) external view returns (uint256) {
        for (uint256 i = 0; i < numbers.length; i++) {
            if (numbers[i] == _num) {
                return i;
            }
        }
        return type(uint256).max; // Not found
    }

    function getLength() external view returns (uint256) {
        return numbers.length;
    }
}


contract CostlyOperationOptimizado {
    uint256[] private numbers;
    mapping(uint256 => uint256) private numberIndex;
    uint256 private totalSum;

    function addNumber(uint256 _num) external {
        numbers.push(_num);
        numberIndex[_num] = numbers.length - 1;
        totalSum += _num;
    }

    // Optimizado: mantenemos el total actualizado
    function sumAll() external view returns (uint256) {
        return totalSum;
    }

    // Optimizado: usamos mapping para busqueda O(1)
    function findNumber(uint256 _num) external view returns (uint256) {
        if (numberIndex[_num] > 0 || numbers[0] == _num) {
            return numberIndex[_num];
        }
        return type(uint256).max; // Not found
    }

    function getLength() external view returns (uint256) {
        return numbers.length;
    }
}