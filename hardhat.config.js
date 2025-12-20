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
  amoy: { // Заменили "mumbai" на "amoy"
    url: "https://rpc-amoy.polygon.technology", // Официальный RPC от Polygon
    accounts: [`0x${process.env.PRIVATE_KEY}`]
  },
    localhost: {
      url: "http://127.0.0.1:8545"
    }
  }
};
