// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract CreatorToken is ERC20, AccessControl {
    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");
    
    constructor() ERC20("CreatorTime", "CTK") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _mint(msg.sender, 1000000 * 10 ** 18);
    }
    
    function registerCreator() public {
        grantRole(CREATOR_ROLE, msg.sender);
    }
}
