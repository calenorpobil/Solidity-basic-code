// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {UserCrud} from "../src/CRUD.sol";

contract CRUDTest is Test {
    UserCrud public userCrud;

    function setUp() public {
        userCrud = new UserCrud();
    }

    // ============ CREATE USER TESTS ============

    function test_CreateUser() public {
        userCrud.createUser("Alice", 25);

        UserCrud.User memory user = userCrud.readUser(1);
        assertEq(user.id, 1);
        assertEq(user.name, "Alice");
        assertEq(user.age, 25);
        assertTrue(user.isActive);
    }

    function test_CreateMultipleUsers() public {
        userCrud.createUser("Alice", 25);
        userCrud.createUser("Bob", 30);
        userCrud.createUser("Charlie", 35);

        UserCrud.User memory user1 = userCrud.readUser(1);
        UserCrud.User memory user2 = userCrud.readUser(2);
        UserCrud.User memory user3 = userCrud.readUser(3);

        assertEq(user1.name, "Alice");
        assertEq(user2.name, "Bob");
        assertEq(user3.name, "Charlie");
    }

    function test_CreateUser_EventEmission() public {
        vm.expectEmit(true, false, false, true);
        emit UserCrud.UserCreated(1, "Alice", 25);
        userCrud.createUser("Alice", 25);
    }

    function testFuzz_CreateUser(string memory _name, uint256 _age) public {
        vm.assume(bytes(_name).length > 0);
        userCrud.createUser(_name, _age);

        UserCrud.User memory user = userCrud.readUser(1);
        assertEq(user.name, _name);
        assertEq(user.age, _age);
    }

    // ============ READ USER TESTS ============

    function test_ReadUser() public {
        userCrud.createUser("Alice", 25);

        UserCrud.User memory user = userCrud.readUser(1);
        assertEq(user.id, 1);
        assertEq(user.name, "Alice");
        assertEq(user.age, 25);
        assertTrue(user.isActive);
    }

    function test_ReadUser_NonExistent() public {
        vm.expectRevert("El usuario no existe");
        userCrud.readUser(999);
    }

    function test_ReadUser_DeletedUser() public {
        userCrud.createUser("Alice", 25);
        userCrud.deleteUser(1);

        vm.expectRevert("El usuario esta inactivo");
        userCrud.readUser(1);
    }

    // ============ UPDATE USER TESTS ============

    function test_UpdateUser() public {
        userCrud.createUser("Alice", 25);
        userCrud.updateUser(1, "Alice Updated", 26);

        UserCrud.User memory user = userCrud.readUser(1);
        assertEq(user.name, "Alice Updated");
        assertEq(user.age, 26);
    }

    function test_UpdateUser_NonExistent() public {
        vm.expectRevert("El usuario no existe");
        userCrud.updateUser(999, "Name", 30);
    }

    function test_UpdateUser_DeletedUser() public {
        userCrud.createUser("Alice", 25);
        userCrud.deleteUser(1);

        vm.expectRevert("El usuario esta inactivo");
        userCrud.updateUser(1, "New Name", 30);
    }

    function test_UpdateUser_EventEmission() public {
        userCrud.createUser("Alice", 25);

        vm.expectEmit(true, false, false, true);
        emit UserCrud.UserUpdated(1, "Alice Updated", 26);
        userCrud.updateUser(1, "Alice Updated", 26);
    }

    function testFuzz_UpdateUser(string memory _newName, uint256 _newAge) public {
        vm.assume(bytes(_newName).length > 0);
        userCrud.createUser("Alice", 25);
        userCrud.updateUser(1, _newName, _newAge);

        UserCrud.User memory user = userCrud.readUser(1);
        assertEq(user.name, _newName);
        assertEq(user.age, _newAge);
    }

    // ============ DELETE USER TESTS ============

    function test_DeleteUser() public {
        userCrud.createUser("Alice", 25);
        userCrud.deleteUser(1);

        vm.expectRevert("El usuario esta inactivo");
        userCrud.readUser(1);
    }

    function test_DeleteUser_NonExistent() public {
        vm.expectRevert("El usuario no existe");
        userCrud.deleteUser(999);
    }

    function test_DeleteUser_AlreadyDeleted() public {
        userCrud.createUser("Alice", 25);
        userCrud.deleteUser(1);

        vm.expectRevert("El usuario esta inactivo");
        userCrud.deleteUser(1);
    }

    function test_DeleteUser_EventEmission() public {
        userCrud.createUser("Alice", 25);

        vm.expectEmit(true, false, false, true);
        emit UserCrud.UserDeleted(1);
        userCrud.deleteUser(1);
    }

    // ============ GET ALL ACTIVE USERS TESTS ============

    function test_GetAllActiveUsers_Empty() public view {
        UserCrud.User[] memory activeUsers = userCrud.getAllActiveUsers();
        assertEq(activeUsers.length, 0);
    }

    function test_GetAllActiveUsers_SingleUser() public {
        userCrud.createUser("Alice", 25);

        UserCrud.User[] memory activeUsers = userCrud.getAllActiveUsers();
        assertEq(activeUsers.length, 1);
        assertEq(activeUsers[0].name, "Alice");
    }

    function test_GetAllActiveUsers_MultipleUsers() public {
        userCrud.createUser("Alice", 25);
        userCrud.createUser("Bob", 30);
        userCrud.createUser("Charlie", 35);

        UserCrud.User[] memory activeUsers = userCrud.getAllActiveUsers();
        assertEq(activeUsers.length, 3);
    }

    function test_GetAllActiveUsers_AfterDeletion() public {
        userCrud.createUser("Alice", 25);
        userCrud.createUser("Bob", 30);
        userCrud.createUser("Charlie", 35);

        userCrud.deleteUser(2); // Delete Bob

        UserCrud.User[] memory activeUsers = userCrud.getAllActiveUsers();
        assertEq(activeUsers.length, 2);
        assertEq(activeUsers[0].name, "Alice");
        assertEq(activeUsers[1].name, "Charlie");
    }

    function test_GetAllActiveUsers_AllDeleted() public {
        userCrud.createUser("Alice", 25);
        userCrud.createUser("Bob", 30);

        userCrud.deleteUser(1);
        userCrud.deleteUser(2);

        UserCrud.User[] memory activeUsers = userCrud.getAllActiveUsers();
        assertEq(activeUsers.length, 0);
    }

    // ============ INTEGRATION TESTS ============

    function test_FullCRUDLifecycle() public {
        // Create
        userCrud.createUser("Alice", 25);
        UserCrud.User memory user = userCrud.readUser(1);
        assertEq(user.name, "Alice");
        assertEq(user.age, 25);

        // Update
        userCrud.updateUser(1, "Alice Smith", 26);
        user = userCrud.readUser(1);
        assertEq(user.name, "Alice Smith");
        assertEq(user.age, 26);

        // Verify in active list
        UserCrud.User[] memory activeUsers = userCrud.getAllActiveUsers();
        assertEq(activeUsers.length, 1);

        // Delete
        userCrud.deleteUser(1);
        activeUsers = userCrud.getAllActiveUsers();
        assertEq(activeUsers.length, 0);
    }
}
