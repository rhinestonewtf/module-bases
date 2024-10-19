// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;
/* solhint-disable no-unused-vars */

contract MockStatelessValidator {
    function onInstall(bytes calldata data) external virtual { }
    function onUninstall(bytes calldata data) external virtual { }

    function isModuleType(uint256 typeID) external pure returns (bool) {
        return typeID == 7;
    }

    function isInitialized(address smartAccount) external pure returns (bool) {
        return true;
    }

    function validateSignatureWithData(
        bytes32 hash,
        bytes calldata sig,
        bytes calldata data
    )
        external
        view
        virtual
        returns (bool validSig)
    {
        return true;
    }
}
