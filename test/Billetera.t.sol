// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Billetera} from "../src/Billetera.sol";

contract BilleteraTest is Test {
    Billetera public billetera;

    function setUp() public {
        billetera = new Billetera();
    }

    function testSetOwner() public {
        billetera.setOwner(address(1));
        assertEq(billetera.owner(), address(1));
    }

    function test_FailSetOwnerAgain() public {
        //msg.sender == address(this)
        //billetera.setOwner(address(1));

        //Version 1
        //Prank hace que el propietario sea la dirección dada por una línea:
        vm.prank(address(1));
        vm.expectRevert("No se pudo verificar al propietario. ");
        billetera.setOwner(address(1));

        vm.startPrank(address(1));

        vm.expectRevert("No se pudo verificar al propietario. ");
        billetera.setOwner(address(1));
        vm.expectRevert("No se pudo verificar al propietario. ");
        billetera.setOwner(address(1));
        vm.expectRevert("No se pudo verificar al propietario. ");
        billetera.setOwner(address(1));

        vm.stopPrank();

        //Fallará porque el propietario ya no es address(1):
        //billetera.setOwner(address(1));
    }
}
