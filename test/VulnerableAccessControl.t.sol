// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {VulnerableAccessControl} from "../src/VulnerableAccessControl.sol";
import {SecureAccessControl} from "../src/VulnerableAccessControl.sol";

contract VulnerableAccessControlTest is Test {
    VulnerableAccessControl public vulnerableAccessControl;
    uint public secretNumber;

    function setUp() public {
        vulnerableAccessControl = new VulnerableAccessControl();
    }
    
    function test_setSecretNumber(uint _newNumber) public {
        secretNumber = _newNumber;
    }

    function test_getSecretNumber() public view returns (uint)  {
        return secretNumber;
    }
}

contract SecureAccessControlTest is Test {
    SecureAccessControl public secureAccessControl;
    uint public secretNumber;

    function setUp() public {
        secureAccessControl = new SecureAccessControl();
    }
    
    function test_setSecretNumber(uint _newNumber) public {
        vm.prank(address(1));
        vm.expectRevert(bytes("Solo el propietario puede acceder a esta funcion"));    
        secureAccessControl.setSecretNumber(_newNumber);
    }

    function test_getSecretNumber() public returns (uint)  {
        vm.prank(address(1));
        vm.expectRevert(bytes("Solo el propietario puede acceder a esta funcion"));      
        secretNumber = secureAccessControl.getSecretNumber();
        return secretNumber;
    }
}
