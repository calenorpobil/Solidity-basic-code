// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Subasta} from "../src/Subasta.sol";

contract SubastaTest is Test {
    Subasta public subasta;

    uint256 private inicio;

    function setUp() public {
        subasta = new Subasta();
        inicio = block.timestamp;
    }

    function test_ofertaAntesDeTiempo() public {
        vm.expectRevert(bytes("No puede ofertar"));
        subasta.oferta();
    }

    function test_oferta() public {
        vm.warp(inicio + 2 days);
        subasta.oferta();
    }

    function test_ofertaFallaDespuesDeFinalizado() public {
        vm.warp(inicio + 3 days);
        vm.expectRevert(bytes("No puede ofertar"));
        subasta.oferta();
    }

    function test_timestamp() public {
        uint256 t = block.timestamp;

        //skip - increment current timestamp
        skip(100);
        assertEq(block.timestamp, t + 100);

        //rewind - decrement current timestamp
        rewind(10);
        assertEq(block.timestamp, t + 90);

        //roll -
    }

    function test_blockNumber() public {
        uint256 b = block.number;
        vm.roll(555);
        assertEq(block.number, 555);
        //assertEq(b, 555); //falla
    }
}
