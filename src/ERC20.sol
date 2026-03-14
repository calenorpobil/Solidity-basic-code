// SPDX-License-Identifier: MIT
pragma solidity ^0.8;


import "./interfaces/IERC20.sol";
import "./interfaces/IERC20Metadata.sol";

contract ERC20 is IERC20, IERC20Metadata {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    // Permisos de gasto de los tokens:
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    // FUNCIONES OPCIONALES
    function name() external view override returns (string memory) {
        return _name;
    }

    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    function decimals() external pure override returns (uint8) {
        return 18;
    }

    // FUNCIONES OBLIGATORIAS
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transfer(recipient, amount);
    }

    function _transfer(address recipient, uint256 amount) internal returns (bool) {
        address owner = msg.sender;
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(_balances[owner] >= amount, "ERC20: transfer amount exceeds balance");

        _balances[owner] -= amount;
        _balances[recipient] += amount;

        emit Transfer(owner, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        return _approve(msg.sender, spender, amount);
    }

    function _approve(address _owner, address _spender, uint256 _amount) internal returns (bool) {
        require(_spender != address(0), "ERC20: approve to the zero address");
        require(_owner != address(0), "ERC20: approve    from the zero address");

        _allowances[_owner][_spender] = _amount;

        emit Approval(_owner, _spender, _amount);
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function transferFrom(address _from, address _to, uint256 _amount) external override returns (bool) {
        require(_allowances[_from][msg.sender] >= _amount, "ERC20: transfer amount exceeds allowance");

        _spendAllowance(_from, msg.sender, _amount);
        _transfer(_from, _to, _amount);
        return true;
    }

    function _transfer(address _from, address _to, uint256 _amount) internal {
        require(_from != address(0), "ERC20: transfer from the zero address");
        require(_to != address(0), "ERC20: transfer to the zero address");

        uint fromBalance = _balances[_from];
        require(_balances[_from] >= _amount, "ERC20: transfer amount exceeds balance");

        unchecked {
            _balances[_from] = fromBalance - _amount;
        }
        _balances[_to] += _amount;

        emit Transfer(_from, _to, _amount);
    }

    function  _spendAllowance(address _owner, address _spender, uint256 _amount) internal {
        uint256 currentAllowance = _allowances[_owner][_spender];

        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= _amount, "ERC20: insufficient allowance");
            _approve(_owner, _spender, currentAllowance - _amount);
        }
    }

    // FUNCIONES ADICIONALES

    // Creación de nuevo token
    function _mint(address _account, uint256 _amount) internal {
        require(_account != address(0), "ERC20: mint to the zero address");

        _totalSupply += _amount;
        _balances[_account] += _amount;

        emit Transfer(address(0), _account, _amount);
    }

    // Quema de tokens
    function _burn(address _account, uint256 _amount) internal {
        require(_account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[_account];
        require(accountBalance >= _amount, "ERC20: burn amount exceeds balance");
        _balances[_account] = accountBalance - _amount;
        _totalSupply -= _amount;

        emit Transfer(_account, address(0), _amount);
    }

    function increaseTotalSupply(address _account, uint256 _amount) public {
        // No es lo mismo que "crear nuevos tokens" en la práctica
        _mint(_account, _amount);
    }


}