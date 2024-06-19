// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

/**
 * a demo to make delegate call solidity
 * @title
 * @author
 * @notice
 */
contract SafeProxy1 {
    address singleton;

    constructor(address _singleton) {
        require(_singleton != address(0), "Invalid singleton address provided");
        singleton = _singleton;
    }

    /**
     * 当你call这个 proxy的时候 找不到 selector的时候都会走fallback方法
     */
    fallback() external payable {
        assembly {
            //1 先提供个方法来获取singleton;
            let _singleton := sload(0)
            if eq(calldataload(0), 0xa619486e00000000000000000000000000000000000000000000000000000000) {
                mstore(0, shr(12, shl(12, _singleton)))
                return(0, 0x20)
            }

            //接下来就是去delegatecall了
            //将call data copy到memory中
            calldatacopy(0, 0, calldatasize())

            // 执行 delegatecall
            let success := delegatecall(gas(), _singleton, 0, calldatasize(), 0, 0)

            //将上一个call返回的 returndata copy到 memory的 0起始位置
            returndatacopy(0, 0, returndatasize())

            if eq(success, 0) {
                //如果失败了
                revert(0, returndatasize())
            }

            return(0, returndatasize())
        }
    }
}
