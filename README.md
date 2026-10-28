# Фабрика криптозомби

Практическая работа 01: смарт-контракт `ZombieFactory` на Solidity ^0.8.20 и тесты на Foundry (Forge).

Каждый адрес может создать одного зомби с именем, ДНК и временем создания. Контракт хранит зомби, их владельцев и сообщает о создании через событие `ZombieCreated`.

## Структура

- `src/ZombieFactory.sol` — контракт
- `test/ZombieFactory.t.sol` — тесты

## API контракта

| Функция | Описание |
| --- | --- |
| `createZombie(string name) returns (uint256 id)` | Создаёт зомби для `msg.sender`. Ошибки: `"Empty name"`, `"Already has zombie"` |
| `totalZombies() returns (uint256)` | Количество созданных зомби |
| `getZombie(uint256 id) returns (string, uint256, uint256)` | `name`, `dna`, `createdAt` |
| `zombieToOwner(uint256 id) returns (address)` | Владелец зомби |
| `ownerZombieCount(address owner) returns (uint256)` | Количество зомби у адреса |
| `DNA_MODULUS` | `10 ** 16`, верхняя граница ДНК (не включительно) |

ДНК: `uint256(keccak256(abi.encodePacked(msg.sender, name))) % DNA_MODULUS`.

## Запуск

```shell
forge build
forge test -vv
```

## Тесты

1. `testAliceCreatesZombie` — верный id, имя, владелец, время, счётчики увеличились
2. `testTwoOwnersCreateSeparateZombies` — два адреса создают по зомби, id различаются
3. `testRevertsOnEmptyName` — пустое имя отклоняется с `"Empty name"`
4. `testRevertsOnSecondZombieForSameOwner` — повторное создание отклоняется с `"Already has zombie"`
5. `testDnaIsBelowModulus` — ДНК меньше `DNA_MODULUS`

Результат `forge test -vv`:

```
Ran 5 tests for test/ZombieFactory.t.sol:ZombieFactoryTest
[PASS] testAliceCreatesZombie() (gas: 216193)
[PASS] testDnaIsBelowModulus() (gas: 188915)
[PASS] testRevertsOnEmptyName() (gas: 33744)
[PASS] testRevertsOnSecondZombieForSameOwner() (gas: 198899)
[PASS] testTwoOwnersCreateSeparateZombies() (gas: 342500)
Suite result: ok. 5 passed; 0 failed; 0 skipped; finished in 549.75µs (912.00µs CPU time)

Ran 1 test suite in 4.32ms (549.75µs CPU time): 5 tests passed, 0 failed, 0 skipped (5 total tests)
```

## Почему вычисление ДНК не является безопасной случайностью?

ДНК полностью определяется адресом отправителя и именем: оба значения известны заранее, а `keccak256` детерминирован, поэтому любой может вычислить результат до отправки транзакции. Подбирая имя (или адрес), пользователь может получить нужную ему ДНК. Для розыгрышей и наград с реальной ценностью нужен внешний источник случайности (например, Chainlink VRF) или схема commit-reveal.
