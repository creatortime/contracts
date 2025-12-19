// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract CreatorToken is ERC20, AccessControl, ReentrancyGuard {
    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");
    bytes32 public constant ORACLE_ROLE = keccak256("ORACLE_ROLE");
    
    uint256 public constant BASE_DAILY_REWARD = 1 ether;
    uint256 public constant CLAIM_COOLDOWN = 1 days;
    uint256 public constant MAX_SUPPLY = 10_000_000 * 10**18;
    
    struct Creator {
        address wallet;
        string category;
        string profileId;
        uint256 reputation;
        uint256 lastClaim;
        uint256 totalEarned;
        bool isActive;
    }
    
    mapping(address => Creator) public creators;
    
    event CreatorRegistered(address indexed creator, string category, string profileId);
    event TimeClaimed(address indexed creator, uint256 amount, uint256 timestamp);
    
    constructor() ERC20("CreatorTime", "CTK") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ORACLE_ROLE, msg.sender);
        _mint(msg.sender, 1_000_000 * 10**18);
    }
    
    function registerCreator(string memory category, string memory profileId) external nonReentrant {
        require(!creators[msg.sender].isActive, "Already registered");
        
        creators[msg.sender] = Creator({
            wallet: msg.sender,
            category: category,
            profileId: profileId,
            reputation: 100,
            lastClaim: 0,
            totalEarned: 0,
            isActive: true
        });
        
        _grantRole(CREATOR_ROLE, msg.sender);
        emit CreatorRegistered(msg.sender, category, profileId);
    }
    
    function claimDailyTime() external nonReentrant {
        require(creators[msg.sender].isActive, "Not registered");
        require(block.timestamp >= creators[msg.sender].lastClaim + CLAIM_COOLDOWN, "Wait 24h");
        
        uint256 reward = BASE_DAILY_REWARD * creators[msg.sender].reputation / 100;
        
        creators[msg.sender].lastClaim = block.timestamp;
        creators[msg.sender].totalEarned += reward;
        
        _mint(msg.sender, reward);
        emit TimeClaimed(msg.sender, reward, block.timestamp);
    }
    
    function getCreatorInfo(address creator) external view returns (
        string memory category,
        string memory profileId,
        uint256 reputation,
        uint256 lastClaim,
        uint256 totalEarned,
        bool isActive
    ) {
        Creator memory c = creators[creator];
        return (c.category, c.profileId, c.reputation, c.lastClaim, c.totalEarned, c.isActive);
    }
}
