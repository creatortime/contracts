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
    mumbai: {
      // === ВАРИАНТЫ RPC (РАСКОММЕНТИРУЙТЕ ОДИН!) ===
      // Основной вариант:
      url: "https://polygon-testnet.public.blastapi.io",
      
      // Альтернативные, если основной не работает:
      // url: "https://polygon-mumbai.gateway.tenderly.co",
      // url: "https://rpc.ankr.com/polygon_mumbai",
      // url: "https://polygon-mumbai-bor.publicnode.com",
      
      accounts: [`0x${process.env.PRIVATE_KEY}`]
    },
    localhost: {
      url: "http://127.0.0.1:8545"
    }
  }
};
