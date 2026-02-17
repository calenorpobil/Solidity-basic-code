// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract Billetera {
    address payable public owner;

    constructor() payable {
        owner = payable(msg.sender);
    }

    receive() external payable {}

    function retirar(uint256 cantidad) external {
        require(msg.sender == owner, "No se pudo verificar al propietario. ");
        payable(msg.sender).transfer(cantidad);
    }

    function setOwner(address _owner) external {
        require(msg.sender == owner, "No se pudo verificar al propietario. ");
        owner = payable(_owner);
    }
}
