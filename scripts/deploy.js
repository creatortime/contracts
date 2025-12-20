async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Деплой с аккаунта:", deployer.address);

  const CreatorToken = await ethers.getContractFactory("CreatorToken");
  const contract = await CreatorToken.deploy();

  await contract.waitForDeployment();
  const address = await contract.getAddress();
  
  console.log("✅ Контракт задеплоен по адресу:", address);
  console.log("🔗 Проверить: https://mumbai.polygonscan.com/address/" + address);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
