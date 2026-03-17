// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "./ERC20.sol";

contract Main {
    ERC20 private _token;
    address private owner;
    address private contractAddress;

    constructor() {
        _token = new ERC20("TEST Coin", "TCI", 18);
        owner = msg.sender;
        contractAddress = address(this);
    }

    // Funcion para obtener el precio del token
    function priceTokens(uint256 _numTokens) public pure returns (uint256) {
        return _numTokens * 1 ether;
    }

    // Funcion para hacer la venta de un token
    function buyTokens(address _client, uint256 _amount) public payable {
        uint256 price = priceTokens(_amount);
        require(msg.value >= price, "buy more tokens");
        uint256 returnValue = msg.value - price;
        payable(msg.sender).transfer(returnValue);
        _token.transfer(_client, _amount);
    }

    // Funcion para generar nuevos tokens
    function generateTokens(uint256 amount) public {
        _token.increaseTotalSupply(contractAddress, amount);
    }

    // Funcion para obtener la direccion del smartcontract
    function getContractAddress() public view returns (address) {
        return contractAddress;
    }

    // Funcion para obtener el balance de una cuenta
    function balanceAccount(address _account) public view returns (uint256) {
        return _token.balanceOf(_account);
    }
}
