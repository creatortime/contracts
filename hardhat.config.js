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
  sepolia: {
    url: "https://ethereum-sepolia.publicnode.com", // Надёжный публичный RPC
    accounts: [`0x${process.env.PRIVATE_KEY}`]
  }
  }
};
