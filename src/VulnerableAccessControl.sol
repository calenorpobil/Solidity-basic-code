// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8;

contract VulnerableAccessControl {
    uint256 secretNumber;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function setSecretNumber(uint256 _newNumber) public {
        secretNumber = _newNumber;
    }

    function getSecretNumber() public view returns (uint256) {
        return secretNumber;
    }
}

contract SecureAccessControl {
    uint256 secretNumber;
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el propietario puede acceder a esta funcion");
        _;
    }

    function setSecretNumber(uint256 _newNumber) public onlyOwner {
        secretNumber = _newNumber;
    }

    function getSecretNumber() public view onlyOwner returns (uint256) {
        return secretNumber;
    }
}
