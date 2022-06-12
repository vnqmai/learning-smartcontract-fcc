const { ethers, getNamedAccounts } = require("hardhat");

const main = async () => {
  const deployer = (await getNamedAccounts()).deployer;
  const fundMe = await ethers.getContract("FundMe", deployer);
  console.log("Funding...");
  const transactionResponse = await fundMe.fund({
    value: ethers.utils.parseEther("0.1"),
  });
  await transactionResponse.wait();
  console.log("Funded!");
};

main()
  .then(() => process.exit(0))
  .catch((e) => {
    console.log(e);
    process.exit(1);
  });
