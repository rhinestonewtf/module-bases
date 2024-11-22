// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import { ERC7579HybridValidatorBase } from "../ERC7579HybridValidatorBase.sol";
import { PackedUserOperation } from "../external/ERC4337.sol";

contract MockHybridValidator is ERC7579HybridValidatorBase {
    function onInstall(bytes calldata data) external virtual override { }

    function onUninstall(bytes calldata data) external virtual override { }

    function validateUserOp(
        PackedUserOperation calldata, // userOp
        bytes32 // userOpHash
    )
        external
        virtual
        override
        returns (ValidationData)
    {
        return
            _packValidationData({ sigFailed: false, validUntil: type(uint48).max, validAfter: 0 });
    }

    function isValidSignatureWithSender(
        address, // sender
        bytes32, // hash
        bytes calldata // data
    )
        external
        view
        virtual
        override
        returns (bytes4)
    {
        return EIP1271_SUCCESS;
    }

    function isModuleType(uint256 typeID) external pure override returns (bool) {
        return typeID == TYPE_VALIDATOR || typeID == 7;
    }

    function isInitialized(
        address // smartAccount
    )
        external
        pure
        returns (bool)
    {
        return false;
    }

    function validateSignatureWithData(
        bytes32,
        bytes calldata,
        bytes calldata
    )
        external
        pure
        override
        returns (bool validSig)
    {
        return true;
    }
}
