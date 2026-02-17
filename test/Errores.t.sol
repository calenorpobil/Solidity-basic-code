// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Errores} from "../src/Errores.sol";

contract ErroresTest is Test {
    Errores public err;

    function setUp() public {
        err = new Errores();
    }

    function test_Fail() public view {
        //Esto no da error en el vídeo, no entiendo por qué.
        err.throwError();
    }

    function test_Revert() public {
        vm.expectRevert();
        err.throwError();
    }

    function test_RequireMessage() public {
        //Al ponerle un mensaje, tiene que ser el mismo que
        //el que va a enviarse:
        vm.expectRevert(bytes("No Autorizado"));
        err.throwError();

        /*
        Esto daría error:
        vm.expectRevert(bytes("No auth"));
        err.throwError();*/
    }

    function test_CustomError() public {
        vm.expectRevert(Errores.NoAutorizado.selector);
        err.throwCustomError();
    }

    function test_ErrorLabel() public pure {
        assertEq(uint256(1), uint256(1), "Test 1");
        assertEq(uint256(1), uint256(1), "Test 2"); //Esta fallará
        assertEq(uint256(1), uint256(1), "Test 3");
    }
}
