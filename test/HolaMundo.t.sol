// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/HolaMundo.sol";

contract HolaMundoTest is Test {
    HolaMundo public holaMundo;

    function setUp() public {
        holaMundo = new HolaMundo();
    }

    function testObtenerMensaje() public view {
        string memory mensaje = holaMundo.obtenerMensaje();

        assertEq(mensaje, "Hola Mundo desde Foundry");
    }

    function testActualizarMensaje() public {
        string memory nuevoMensaje = "Hola desde el test";

        holaMundo.actualizarMensaje(nuevoMensaje);

        string memory mensajeActualizado = holaMundo.obtenerMensaje();

        assertEq(mensajeActualizado, nuevoMensaje);
    }
}
