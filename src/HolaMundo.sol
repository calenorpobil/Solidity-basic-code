// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract HolaMundo {
    string private mensaje;

    constructor() {
        mensaje = "Hola Mundo desde Foundry";
    }

    function obtenerMensaje() public view returns (string memory) {
        return mensaje;
    }

    function actualizarMensaje(string memory _nuevoMensaje) public {
        mensaje = _nuevoMensaje;
    }
}
