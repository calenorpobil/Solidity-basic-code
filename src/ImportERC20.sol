// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "solmate/tokens/ERC20.sol";

/*$ git add .

$ git commit -m "Commit"
$ forge install rari-capital/solmate*/

//tomamos los parámetros del constructor de la librería padre:
contract Token is ERC20("CoinTest", "CTE", 18) {}

/*$ forge remappings
ds-test/=lib/solmate/lib/ds-test/src/
forge-std/=lib/forge-std/src/
solmate/=lib/solmate/src/

$ forge update lib/solmate

$ forge remove solmate

*/

