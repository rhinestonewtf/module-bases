// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.25;

import { ERC7579PolicyBase } from "./ERC7579PolicyBase.sol";
import { ConfigId, I1271Policy } from "./interfaces/IPolicy.sol";

abstract contract ERC75791271Policy is ERC7579PolicyBase, I1271Policy {
    function check1271SignedAction(
        ConfigId id,
        address requestSender,
        address account,
        bytes32 hash,
        bytes calldata signature
    )
        external
        view
        virtual
        returns (bool);
}
