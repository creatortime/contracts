async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);
  
  const CreatorToken = await ethers.getContractFactory("CreatorToken");
  const creatorToken = await CreatorToken.deploy();
  
  await creatorToken.deployed();
  
  console.log("✅ CreatorToken deployed to:", creatorToken.address);
  console.log("📝 Token Name:", await creatorToken.name());
  console.log("🔤 Token Symbol:", await creatorToken.symbol());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
