// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract Errores {
    error NoAutorizado();

    function throwError() external pure {
        require(false, "No Autorizado");
    }

    function throwCustomError() external pure {
        revert NoAutorizado();
    }
}
