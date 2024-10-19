// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { PackedUserOperation } from
    "@ERC4337/account-abstraction/contracts/interfaces/PackedUserOperation.sol";

contract MockPolicy {
    uint256 validationData = 1;
    mapping(
        bytes32 id => mapping(address msgSender => mapping(address userOpSender => uint256 calls))
    ) public userOpState;
    mapping(
        bytes32 id => mapping(address msgSender => mapping(address userOpSender => uint256 calls))
    ) public actionState;

    function setValidationData(uint256 data) external {
        validationData = data;
    }

    function initializeWithMultiplexer(
        address account,
        bytes32 configId,
        bytes calldata initData
    )
        external
    {
        userOpState[configId][msg.sender][account] = 1;
    }

    function checkUserOpPolicy(
        bytes32 id,
        PackedUserOperation calldata userOp
    )
        external
        returns (uint256)
    {
        userOpState[id][msg.sender][userOp.sender] += 1;
        return validationData;
    }

    function checkAction(
        bytes32 id,
        address account,
        address target,
        uint256 value,
        bytes calldata data
    )
        external
        returns (uint256)
    {
        actionState[id][msg.sender][account] += 1;
        return validationData;
    }

    function supportsInterface(bytes4 interfaceID) external view returns (bool) {
        return true;
    }

    function check1271SignedAction(
        bytes32 id,
        address requestSender,
        address account,
        bytes32 hash,
        bytes calldata signature
    )
        external
        view
        returns (bool)
    {
        return true;
    }
}
