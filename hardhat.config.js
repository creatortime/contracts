require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    // Локальная сеть для очень быстрого тестирования
    localhost: {
      url: "http://127.0.0.1:8545"
    },
    // Новая целевая тестовая сеть - Sepolia
    sepolia: {
      url: "https://ethereum-sepolia.publicnode.com", // Надежный бесплатный RPC-узел
      accounts: [`0x${process.env.PRIVATE_KEY}`] // Ключ берется из .env файла
    }
  }
};
