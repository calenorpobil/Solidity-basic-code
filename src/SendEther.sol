// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract SendEther {
    address payable public owner;

    event Deposit(address account, uint256 amount);

    constructor() payable {
        owner = payable(msg.sender);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function retirar(uint256 cantidad) external {
        require(msg.sender == owner, "No se pudo verificar al propietario. ");
        payable(msg.sender).transfer(cantidad);
    }

    function setOwner(address _owner) external {
        require(msg.sender == owner, "No se pudo verificar al propietario. ");
        owner = payable(_owner);
    }
}
