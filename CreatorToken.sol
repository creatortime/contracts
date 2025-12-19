// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract CreatorToken is ERC20, AccessControl, ReentrancyGuard {
    // Роли для управления
    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");
    bytes32 public constant ORACLE_ROLE = keccak256("ORACLE_ROLE");
    
    // Константы
    uint256 public constant BASE_DAILY_REWARD = 1 ether; // 1 CTK в день
    uint256 public constant CLAIM_COOLDOWN = 1 days; // 24 часа
    uint256 public constant MAX_SUPPLY = 10_000_000 * 10**18; // 10 млн CTK
    
    // Структура данных создателя
    struct Creator {
        address wallet;
        string category;
        string profileId;
        uint256 reputation;
        uint256 lastClaim;
        uint256 totalEarned;
        bool isActive;
    }
    
    // Маппинги (исправленный синтаксис с =>)
    mapping(address => Creator) public creators;
    
    // События
    event CreatorRegistered(address indexed creator, string category, string profileId);
    event TimeClaimed(address indexed creator, uint256 amount, uint256 timestamp);
    event WorkVerified(address indexed creator, uint256 hours, uint256 reward);
    event ReputationUpdated(address indexed creator, uint256 newReputation);
    
    // Конструктор
    constructor() ERC20("CreatorTime", "CTK") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ORACLE_ROLE, msg.sender);
        _mint(msg.sender, 1_000_000 * 10**18); // Начальная ликвидность
    }
    
    // Регистрация создателя
    function registerCreator(
        string memory category,
        string memory profileId
    ) external nonReentrant {
        require(!creators[msg.sender].isActive, "Already registered");
        require(bytes(category).length > 0, "Category required");
        
        creators[msg.sender] = Creator({
            wallet: msg.sender,
            category: category,
            profileId: profileId,
            reputation: 100, // Начальная репутация
            lastClaim: 0,
            totalEarned: 0,
            isActive: true
        });
        
        _grantRole(CREATOR_ROLE, msg.sender);
        emit CreatorRegistered(msg.sender, category, profileId);
    }
    
    // Получение ежедневной награды
    function claimDailyTime() external nonReentrant {
        require(creators[msg.sender].isActive, "Not registered");
        require(block.timestamp >= creators[msg.sender].lastClaim + CLAIM_COOLDOWN, "Wait 24h");
        require(totalSupply() + BASE_DAILY_REWARD <= MAX_SUPPLY, "Max supply reached");
        
        uint256 reward = calculateDailyReward(msg.sender);
        
        creators[msg.sender].lastClaim = block.timestamp;
        creators[msg.sender].totalEarned += reward;
        
        _mint(msg.sender, reward);
        emit TimeClaimed(msg.sender, reward, block.timestamp);
    }
    
    // Расчет награды с учетом репутации
    function calculateDailyReward(address creator) public view returns (uint256) {
        uint256 baseReward = BASE_DAILY_REWARD;
        uint256 reputation = creators[creator].reputation;
        return baseReward * reputation / 100; // 100 репутации = 1x, 200 = 2x
    }
    
    // Верификация работы (только для оракулов)
    function verifyWork(
        address creator,
        uint256 hoursWorked,
        bytes32 proofHash
    ) external onlyRole(ORACLE_ROLE) {
        require(creators[creator].isActive, "Creator not active");
        
        uint256 reward = hoursWorked * 10**18; // 1 CTK за час работы
        uint256 bonus = reward * creators[creator].reputation / 1000; // 0.1% бонус за репутацию
        uint256 totalReward = reward + bonus;
        
        require(totalSupply() + totalReward <= MAX_SUPPLY, "Max supply reached");
        
        creators[creator].totalEarned += totalReward;
        creators[creator].reputation += hoursWorked; // Репутация растет с работой
        
        _mint(creator, totalReward);
        emit WorkVerified(creator, hoursWorked, totalReward);
        emit ReputationUpdated(creator, creators[creator].reputation);
    }
    
    // Обновление репутации (только админ)
    function updateReputation(
        address creator,
        uint256 newReputation
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(creators[creator].isActive, "Creator not active");
        creators[creator].reputation = newReputation;
        emit ReputationUpdated(creator, newReputation);
    }
    
    // Получение информации о создателе
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
