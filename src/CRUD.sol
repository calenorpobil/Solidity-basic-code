// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console2.sol";

contract UserCrud {
    struct User {
        uint256 id;
        string name;
        uint256 age;
        bool isActive;
    }

    mapping(uint256 => User) private users;
    uint256 nextId;

    event UserCreated(uint256 id, string name, uint256 age);
    event UserUpdated(uint256 id, string name, uint256 age);
    event UserDeleted(uint256 id);

    // Crear usuarios
    function createUser(string memory _name, uint256 _age) public {
        nextId++;
        users[nextId] = User(nextId, _name, _age, true);
        emit UserCreated(nextId, _name, _age);
    }

    // Leer usuarios
    function readUser(uint256 _id) public view returns (User memory) {
        require(_id > 0 && _id <= nextId, "El usuario no existe");
        require(users[_id].isActive, "El usuario esta inactivo");

        return users[_id];
    }

    // Actualizar usuarios
    function updateUser(uint256 _id, string memory _name, uint256 _age) public {
        require(_id > 0 && _id <= nextId, "El usuario no existe");
        require(users[_id].isActive, "El usuario esta inactivo");

        User storage user = users[_id];
        user.age = _age;
        user.name = _name;

        emit UserUpdated(_id, _name, _age);
    }

    // Eliminar usuario
    function deleteUser(uint256 _id) public {
        require(_id > 0 && _id <= nextId, "El usuario no existe");
        require(users[_id].isActive, "El usuario esta inactivo");
        users[_id].isActive = false;

        emit UserDeleted(_id);
    }

    // Traer todos los registros activos
    function getAllActiveUsers() public view returns(User[] memory) {
        uint256 activeCount = 0;
        for(uint256 i = 1; i <= nextId; i++){
            if(users[i].isActive){
                activeCount++;
            }
        }

        User[] memory activeUsers = new User[](activeCount);
        uint256 index = 0;
        for (uint256 i = 1; i <= nextId; i++) {
            if (users[i].isActive){
                activeUsers[index] = users[i];
                index++;
            }
        }
        return activeUsers;
    }
}
