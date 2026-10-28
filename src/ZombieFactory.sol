// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ZombieFactory {
    struct Zombie {
        string name;
        uint256 dna;
        uint256 createdAt;
    }

    uint256 public constant DNA_MODULUS = 10 ** 16;

    Zombie[] private zombies;
    mapping(uint256 => address) public zombieToOwner;
    mapping(address => uint256) public ownerZombieCount;

    event ZombieCreated(uint256 indexed id, address indexed owner, string name, uint256 dna);
}
