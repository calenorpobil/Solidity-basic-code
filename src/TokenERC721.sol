// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./ERC165.sol";
import "./interfaces/IREC721Receiver.sol";
import "./interfaces/IERC721.sol";

contract TokenERC721 is ERC165, IERC721 {
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    function balanceOf(address owner) public view virtual override returns (uint256){
        require(owner != address(0), "ERC721 ERROR: Address zero");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view virtual override returns (address){
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721 ERROR: Invalid token ID");
        return owner;
    }

    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ownerOf(tokenId);
        require(to != owner, "ERC721 ERROR: Approval to current owner");
        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender), 
            "ERC721 ERROR: Approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);    
    }

    function _approve(address to, uint256 tokenId) internal {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    function getApproved(uint256 tokenid) public view virtual override returns (address) {
        require(_exists(tokenid), "ERC721 ERROR: Invalid token ID");
        return _tokenApprovals[tokenid];
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function setApprovalForAll(address operator, bool _approved) public virtual override {
        require(operator != msg.sender, "ERC721 ERROR: Operator address must be different from caller");
        _operatorApprovals[msg.sender][operator] = _approved;
        emit ApprovalForAll(msg.sender, operator, _approved);
    }

    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721 ERROR: Caller is not token owner nor approved");
        _transfer(from, to, tokenId);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), "ERC721 ERROR: Invalid token ID");
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    // El código a partir de aquí es autogenerado, se escribirá en siguientes commits. 

    function _transfer(address from, address to, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from, "ERC721 ERROR: Transfer from incorrect owner");
        require(to != address(0), "ERC721 ERROR: Transfer to the zero address");

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721 ERROR: Caller is not token owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721 ERROR: Transfer to non ERC721Receiver implementer");
    }

    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
        if (isContract(to)) {
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721 ERROR: Transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function mint(address to, uint256 tokenId) public {
        require(to != address(0), "ERC721 ERROR: Mint to the zero address");
        require(!_exists(tokenId), "ERC721 ERROR: Token already minted");

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    function burn(uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner, "ERC721 ERROR: Caller is not token owner");

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

}
