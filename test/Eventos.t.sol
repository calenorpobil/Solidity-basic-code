// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Eventos} from "../src/Eventos.sol";

contract EventosTest is Test {
    Eventos public eventos;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    function setUp() public {
        eventos = new Eventos();
    }

    function testEmitTransferEvent() public {
        // 1. Indica a Foundry qué datos comprobar
        vm.expectEmit(true, true, false, true);

        // 2. Emite el evento esperado
        emit Transfer(address(this), address(123), 200);
        //200 es la cantidad que queremos enviar.

        // 3. Llama a la función que debería emitir el evento
        eventos.transfer(address(this), address(123), 200);

        // Comprueba un solo indice
        vm.expectEmit(true, true, true, true);
        emit Transfer(address(this), address(123), 400);
        emit Transfer(address(this), address(123), 400);

        eventos.transfer(address(this), address(125), 400);
    }

    function testEmitManyTransferEvent() public {
        address[] memory to = new address[](2);
        to[0] = address(10);
        to[1] = address(11);

        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 150;
        amounts[1] = 151;

        for (uint256 i; i < to.length; i++) {
            // 1. Indica a Foundry qué datos comprobar
            vm.expectEmit(true, true, false, false);
            //Orden de los booleanos: from, to, x, amount.

            // 2. Emite el evento esperado
            emit Transfer(address(this), to[i], amounts[i]);
        }
        // 3. Llama a la función que debería emitir el evento
        amounts[1] = 111;
        //Al cambiar uno de los amounts, fallará el expectEmit.
        //A no ser que el último booleano de expectEmit sea false.
        eventos.transferMany(address(this), to, amounts);
    }
}
