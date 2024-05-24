// SPDX-License-Identifier: GLP
pragma solidity ^0.8.19;
import "../interface/IERC20Minimal.sol";

contract ERC20Lib {
    
    /**
     * 为什么使用这种低级call
     * 在于如果address 如果没有balanceOf的时候
     * 我们可以显式的revert 
     * 
     * IERC20(token).balanceOf(user) 则会直接报错
     * 
     * @param token 
     * @param user 
     */
    function balanceOf(address token, address user) external view returns (uint256) {
        (bool success, bytes memory data) = token.staticcall(
            abi.encodeWithSelector(IERC20Minimal.balanceOf.selector, address(user))
        );
        require(success && bytes.length >= 32);
        return abi.decode(data,(uint256))
    }
}
