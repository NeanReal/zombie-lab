// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {ZombieFactory} from "../src/ZombieFactory.sol";

contract ZombieFactoryTest is Test {
    ZombieFactory factory;
    address alice = address(0xA11CE);

    function setUp() public {
        factory = new ZombieFactory();
    }

    function testAliceCreatesZombie() public {
        vm.warp(1_700_000_000);

        vm.prank(alice);
        uint256 id = factory.createZombie("Alice");

        (string memory name,, uint256 createdAt) = factory.getZombie(id);
        assertEq(id, 0);
        assertEq(name, "Alice");
        assertEq(factory.zombieToOwner(id), alice);
        assertEq(createdAt, 1_700_000_000);
        assertEq(factory.totalZombies(), 1);
        assertEq(factory.ownerZombieCount(alice), 1);
    }
}
