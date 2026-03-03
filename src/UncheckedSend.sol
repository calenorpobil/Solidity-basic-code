// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract UncheckedSendVulnerability {
    mapping(address => uint256) private balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) external {
        require(_amount <= balances[msg.sender], "Saldo insuficiente");

        // Vulnerabilidad: no se verifica el retorno de send()
        // send() devuelve false si la transferencia falla, pero aqui se ignora
        msg.sender.call{value: _amount}("");

        balances[msg.sender] -= _amount;
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}

contract UncheckedSendOptimizado {
    mapping(address => uint256) private balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) external {
        require(_amount <= balances[msg.sender], "Saldo insuficiente");

        // Actualizamos el balance antes de enviar
        balances[msg.sender] -= _amount;

        // Usamos call() y verificamos el resultado
        (bool success,) = payable(msg.sender).call{value: _amount}("");

        require(success, "Transferencia fallida");
    }

    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}
