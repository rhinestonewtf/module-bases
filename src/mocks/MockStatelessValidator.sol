// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract MockStatelessValidator {
    function onInstall(bytes calldata data) external virtual { }

    function onUninstall(bytes calldata data) external virtual { }

    function isModuleType(uint256 typeID) external pure returns (bool) {
        return typeID == 7;
    }

    function isInitialized(address) external pure returns (bool) {
        return true;
    }

    function validateSignatureWithData(
        bytes32,
        bytes calldata,
        bytes calldata
    )
        external
        view
        virtual
        returns (bool validSig)
    {
        return true;
    }
}
