async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  const CreatorToken = await ethers.getContractFactory("CreatorToken");
  const token = await CreatorToken.deploy();

  await token.deployed();
  console.log("CreatorToken deployed to:", token.address);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
