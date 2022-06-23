// build a script that will deposit our token for weth token
const { ethers, getNamedAccounts, network } = require("hardhat");
const AMOUNT = ethers.utils.parseEther("0.1");

const getWeth = async () => {
  const { deployer } = await getNamedAccounts();
  // call the "deposit" function on the weth contract
  // abi(add IWeth.sol interface then yarn hardhat compile), contract address(https://etherscan.io/token/0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2)
  // 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
  const iWeth = await ethers.getContractAt(
    "IWeth",
    "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2",
    deployer
  );
  const tx = await iWeth.deposit({ value: AMOUNT });
  await tx.wait(1);
  const wethBalance = await iWeth.balanceOf(deployer);
  console.log(`Got ${wethBalance.toString()} WETH`);
};

module.exports = {
  getWeth,
  AMOUNT,
};
