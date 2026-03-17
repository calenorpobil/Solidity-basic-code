// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC165.sol";

interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);

    // Antes de transferir, safeTransferFrom verifica que el destinatario es capaz de recibir el token
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
    function transferFrom(address from, address to, uint256 tokenId) external;

    // Da permiso a otra cuenta para transferir un token específico
    function approve(address to, uint256 tokenId) external;
    // Nos devuelve la dirección autorizada para transferir un token específico
    function getApproved(uint256 tokenId) external view returns (address operator);
    // Permite autorizar o revocar una autorización para transferir todos los tokens de una cuenta
    function setApprovalForAll(address operator, bool _approved) external;
    // Verificar si una dirección está autorizada para transferir todos los tokens de una cuenta
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}
