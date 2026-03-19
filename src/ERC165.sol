// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "./interfaces/IERC165.sol";

contract ERC165 is IERC165 {
    // Mapeo de interfaces soportadas
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor() {
        // Registrar la interfaz ERC165
        _registerInterface(type(IERC165).interfaceId);
    }

    // Función para verificar si el contrato soporta una interfaz específica
    function supportsInterface(bytes4 interfaceId) external view override returns (bool) {
        // Compara el ID de la interfaz con el mapeo de interfaces soportadas
        return _supportedInterfaces[interfaceId];
    }

    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}
