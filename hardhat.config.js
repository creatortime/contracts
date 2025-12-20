require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config(); // Эта строка критически важна

module.exports = {
  solidity: "0.8.19",
  networks: {
    mumbai: {
      url: "https://polygon-mumbai-bor.publicnode.com", // Рабочий RPC
      accounts: [`0x${process.env.PRIVATE_KEY}`] // Добавляем 0x здесь
    }
  }
};
