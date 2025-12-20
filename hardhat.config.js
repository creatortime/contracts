require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config(); // Эта строка критически важна

module.exports = {
  solidity: "0.8.19",
  networks: {
  mumbai: {
    // Попробуйте эти RPC по очереди, если первый не сработает
    url: "https://polygon-testnet.public.blastapi.io", // Основной рекомендованный
    // Альтернативы:
    // url: "https://polygon-mumbai.gateway.tenderly.co",
    // url: "https://rpc.ankr.com/polygon_mumbai",
    accounts: [`0x${process.env.PRIVATE_KEY}`]
  }
}
  }
};
