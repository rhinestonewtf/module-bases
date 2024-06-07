// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { ERC7579HookBase } from "../ERC7579HookBase.sol";

contract MockHookMultiPlexer is ERC7579HookBase {
    error PreCheckFailed(address hook);
    error PostCheckFailed(address hook);

    mapping(address => address[]) public hooks;

    function onInstall(bytes calldata data) external override {
        if (data.length == 0) return;
        (address[] memory _hooks) = abi.decode(data, (address[]));
        for (uint256 i = 0; i < _hooks.length; i++) {
            hooks[msg.sender].push(_hooks[i]);
        }
    }

    function onUninstall(bytes calldata) external override {
        delete hooks[msg.sender];
    }

    function addHook(address hook) external {
        hooks[msg.sender].push(hook);
    }

    function removeHook(address hook) external {
        address[] storage _hooks = hooks[msg.sender];
        for (uint256 i = 0; i < _hooks.length; i++) {
            if (_hooks[i] == hook) {
                _hooks[i] = _hooks[_hooks.length - 1];
                _hooks.pop();
                break;
            }
        }
    }

    function isHookInstalled(address account, address hook) external view returns (bool) {
        address[] memory _hooks = hooks[account];
        for (uint256 i = 0; i < _hooks.length; i++) {
            if (_hooks[i] == hook) return true;
        }
        return false;
    }

    function _preCheck(
        address account,
        address msgSender,
        uint256 msgValue,
        bytes calldata msgData
    )
        internal
        override
        returns (bytes memory hookData)
    {
        uint256 length = hooks[account].length;
        if (length == 0) return hookData;

        bytes[] memory _hookData = new bytes[](length);
        for (uint256 i = 0; i < length; i++) {
            (bool success, bytes memory _ret) = hooks[account][i].call(
                abi.encodePacked(
                    abi.encodeCall(ERC7579HookBase.preCheck, (msgSender, msgValue, msgData)),
                    address(this),
                    msg.sender
                )
            );
            if (!success) revert PreCheckFailed(hooks[account][i]);
            _hookData[i] = _ret;
        }
        hookData = abi.encode(_hookData);
    }

    function _postCheck(address account, bytes calldata hookData) internal override {
        uint256 length = hooks[account].length;
        if (length == 0) return;

        bytes[] memory _hookData = new bytes[](length);
        if (hookData.length != 0) {
            _hookData = abi.decode(hookData, (bytes[]));
        }
        for (uint256 i = 0; i < length; i++) {
            (bool success,) = hooks[account][i].call(
                abi.encodePacked(
                    abi.encodeCall(ERC7579HookBase.postCheck, (_hookData[i])),
                    address(this),
                    msg.sender
                )
            );
            if (!success) revert PostCheckFailed(hooks[account][i]);
        }
    }

    function isInitialized(address smartAccount) external view returns (bool) {
        return hooks[smartAccount].length > 0;
    }

    function isModuleType(uint256 typeID) external pure returns (bool) {
        return typeID == TYPE_HOOK;
    }
}
