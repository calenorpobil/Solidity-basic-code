// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {ContratoOptimizado} from "../src/OptimizacionYul.sol";

contract OptimizacionYulTest is Test {
    ContratoOptimizado public contrato;

    function setUp() public {
        contrato = new ContratoOptimizado();
    }

    // ============ SUMA TESTS ============

    function test_Sum() public view {
        uint256 result = contrato.sum(5, 10);
        assertEq(result, 15);
    }

    function test_SumZero() public view {
        uint256 result = contrato.sum(0, 0);
        assertEq(result, 0);
    }

    function test_SumLargeNumbers() public view {
        uint256 a = type(uint256).max - 100;
        uint256 b = 50;
        uint256 result = contrato.sum(a, b);
        assertEq(result, a + b);
    }

    function testFuzz_Sum(uint256 a, uint256 b) public view {
        vm.assume(a <= type(uint256).max - b); // Evitar overflow
        uint256 result = contrato.sum(a, b);
        assertEq(result, a + b);
    }

    // ============ SUMA YUL TESTS ============

    function test_SumYul() public view {
        uint256 result = contrato.sumYul(5, 10);
        assertEq(result, 15);
    }

    function test_SumYulZero() public view {
        uint256 result = contrato.sumYul(0, 0);
        assertEq(result, 0);
    }

    function test_SumYulLargeNumbers() public view {
        uint256 a = type(uint256).max - 100;
        uint256 b = 50;
        uint256 result = contrato.sumYul(a, b);
        assertEq(result, a + b);
    }

    function testFuzz_SumYul(uint256 a, uint256 b) public view {
        vm.assume(a <= type(uint256).max - b); // Evitar overflow
        uint256 result = contrato.sumYul(a, b);
        assertEq(result, a + b);
    }

    // ============ COMPARACION SUMA SOLIDITY VS YUL ============

    function test_SumVsSumYul_EqualResults() public view {
        uint256 a = 100;
        uint256 b = 200;

        uint256 resultSolidity = contrato.sum(a, b);
        uint256 resultYul = contrato.sumYul(a, b);

        assertEq(resultSolidity, resultYul);
    }

    function testFuzz_SumVsSumYul_EqualResults(uint256 a, uint256 b) public view {
        vm.assume(a <= type(uint256).max - b);

        uint256 resultSolidity = contrato.sum(a, b);
        uint256 resultYul = contrato.sumYul(a, b);

        assertEq(resultSolidity, resultYul);
    }

    // ============ HASH TESTS ============

    function test_SolidityHash() public view {
        // La funcion solidityHash no retorna nada, solo verificamos que no revierte
        contrato.solidityHash(100, 200);
    }

    function test_YulHash() public view {
        // La funcion yulHash no retorna nada, solo verificamos que no revierte
        contrato.yulHash(100, 200);
    }

    function testFuzz_SolidityHash(uint256 a, uint256 b) public view {
        contrato.solidityHash(a, b);
    }

    function testFuzz_YulHash(uint256 a, uint256 b) public view {
        contrato.yulHash(a, b);
    }

    // ============ UNCHECKED TESTS ============

    function test_UncheckedSolidity() public view {
        // Verificamos que la funcion ejecuta sin errores
        contrato.uncheckedSolidity();
    }

    function test_UncheckedYul() public view {
        // Verificamos que la funcion ejecuta sin errores
        contrato.uncheckedYul();
    }

    // ============ GAS COMPARISON TESTS ============

    function test_GasComparison_Sum() public {
        uint256 gasBeforeSolidity = gasleft();
        contrato.sum(100, 200);
        uint256 gasAfterSolidity = gasleft();
        uint256 gasUsedSolidity = gasBeforeSolidity - gasAfterSolidity;

        uint256 gasBeforeYul = gasleft();
        contrato.sumYul(100, 200);
        uint256 gasAfterYul = gasleft();
        uint256 gasUsedYul = gasBeforeYul - gasAfterYul;

        // Log para comparacion manual
        emit log_named_uint("Gas usado por sum (Solidity)", gasUsedSolidity);
        emit log_named_uint("Gas usado por sumYul (Yul)", gasUsedYul);

        // Yul deberia usar menos o igual gas que Solidity
        assertLe(gasUsedYul, gasUsedSolidity, "Yul deberia ser mas eficiente que Solidity");
    }

    function test_GasComparison_Hash() public {
        uint256 gasBeforeSolidity = gasleft();
        contrato.solidityHash(100, 200);
        uint256 gasAfterSolidity = gasleft();
        uint256 gasUsedSolidity = gasBeforeSolidity - gasAfterSolidity;

        uint256 gasBeforeYul = gasleft();
        contrato.yulHash(100, 200);
        uint256 gasAfterYul = gasleft();
        uint256 gasUsedYul = gasBeforeYul - gasAfterYul;

        // Log para comparacion manual
        emit log_named_uint("Gas usado por solidityHash", gasUsedSolidity);
        emit log_named_uint("Gas usado por yulHash", gasUsedYul);

        // Yul deberia usar menos o igual gas que Solidity
        assertLe(gasUsedYul, gasUsedSolidity, "Yul hash deberia ser mas eficiente");
    }

    function test_GasComparison_Unchecked() public {
        uint256 gasBeforeSolidity = gasleft();
        contrato.uncheckedSolidity();
        uint256 gasAfterSolidity = gasleft();
        uint256 gasUsedSolidity = gasBeforeSolidity - gasAfterSolidity;

        uint256 gasBeforeYul = gasleft();
        contrato.uncheckedYul();
        uint256 gasAfterYul = gasleft();
        uint256 gasUsedYul = gasBeforeYul - gasAfterYul;

        // Log para comparacion manual
        emit log_named_uint("Gas usado por uncheckedSolidity", gasUsedSolidity);
        emit log_named_uint("Gas usado por uncheckedYul", gasUsedYul);
    }

    // ============ EDGE CASES ============

    function test_Sum_MaxValues() public view {
        uint256 max = type(uint256).max;
        uint256 result = contrato.sum(max, 0);
        assertEq(result, max);
    }

    function test_SumYul_MaxValues() public view {
        uint256 max = type(uint256).max;
        uint256 result = contrato.sumYul(max, 0);
        assertEq(result, max);
    }

    function test_Sum_Overflow() public {
        uint256 max = type(uint256).max;
        vm.expectRevert();
        contrato.sum(max, 1);
    }

    function test_SumYul_Overflow() public view {
        uint256 max = type(uint256).max;
        // Yul assembly no tiene chequeo de overflow por defecto
        // El resultado sera un valor incorrecto (wrap around)
        uint256 result = contrato.sumYul(max, 1);
        assertEq(result, 0); // Overflow wrap around
    }
}
