// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.25;

import { ERC7579PolicyBase } from "./ERC7579PolicyBase.sol";
import { ConfigId, IUserOpPolicy } from "./interfaces/IPolicy.sol";

abstract contract ERC7579UserOpPolicy is ERC7579PolicyBase, IUserOpPolicy {
    function checkUserOp(
        ConfigId id,
        address account,
        address target,
        uint256 value,
        bytes calldata data
    )
        external
        virtual
        returns (uint256);
}
