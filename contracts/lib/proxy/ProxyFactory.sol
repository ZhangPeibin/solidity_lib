// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Proxy.sol";

contract ProxyFactory {
    function depoly(address logicAddress, bytes memory initializer, bytes32 salt) external returns (SafeProxy1 proxy) {
        require(isContract(logicAddress), " logic address is contract ");
        bytes memory depolyBytes = abi.encodePacked(type(SafeProxy1).creationCode, uint256(uint160(logicAddress)));

        assembly {
            proxy := create2(0x00, add(0x20, depolyBytes), mload(depolyBytes), salt)
        }

        require(address(proxy) != address(0), "depoly failed");

        if (initializer.length > 0) {
            assembly {
                let result := call(gas(), logicAddress, 0, add(initializer, 0x20), mload(initializer), 0, 0)
                if eq(result, 0) {
                    revert(0, 0)
                }
            }
        }
    }

    function isContract(address _contractAddress) internal view returns (bool) {
        uint256 byteSize;
        assembly {
            byteSize := extcodesize(_contractAddress)
        }
        return byteSize > 0;
    }
}
