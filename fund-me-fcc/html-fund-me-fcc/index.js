import { abi, contractAddress } from "./constants.js";
import { ethers } from "./ethers-5.2.esm.min.js";

const connect = async () => {
  if (window.ethereum !== "undefined") {
    console.log("I see metamask!");
    // connect metamask wallet
    await window.ethereum.request({ method: "eth_requestAccounts" });
    document.getElementById("connectButton").innerHTML = "Connected!";
    console.log("Connected!");
  } else {
    console.log("NO metamask!");
    console.log("Please install metamask!");
  }
};

const getBalance = async () => {
  if (typeof window.ethereum !== "undefined") {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const balance = await provider.getBalance(contractAddress);
    console.log(ethers.utils.formatEther(balance));
  }
};

const fund = async () => {
  const ethAmount = document.getElementById("ethAmountInput").value;
  console.log(`Funding with ${ethAmount}...`);
  if (typeof window.ethereum !== "undefined") {
    // provider / connection to the blockchain
    // signer / wallet / someone with some gas
    // contract that we are interacting with
    // ^ ABI & Address
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    console.log(signer);
    const contract = new ethers.Contract(contractAddress, abi, signer);
    try {
      const transactionResponse = await contract.fund({
        value: ethers.utils.parseEther(ethAmount),
      });
      // listen for the tx to be mined
      await listenForTransactionMine(transactionResponse, provider);
      console.log("Done!");
      // listen for an event <- we haven't learned about yet!
    } catch (e) {
      console.log(e);
    }
  }
};

const listenForTransactionMine = (transactionResponse, provider) => {
  console.log(`Mining ${transactionResponse.hash}...`);
  // return new Promise() // create a listener for a blockchain
  // listen for this transaction to finish
  return new Promise((resolve, reject) => {
    provider.once(transactionResponse.hash, (transactionReceipt) => {
      console.log(
        `Completed with ${transactionReceipt.confirmations} confirmations`
      );
      resolve();
    });
  });
};

const withdraw = async () => {
  if (typeof window.ethereum !== "undefined") {
    console.log("Withdrawing...");
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(contractAddress, abi, signer);
    try {
      const transactionResponse = await contract.widthdraw();
      await listenForTransactionMine(transactionResponse, provider);
      console.log("Done!");
    } catch (e) {
      console.log(e);
    }
  }
};

const connectButton = document.getElementById("connectButton");
const fundButton = document.getElementById("fundButton");
const balanceButton = document.getElementById("balanceButton");
const withdrawButton = document.getElementById("withdrawButton");
connectButton.onclick = connect;
fundButton.onclick = fund;
balanceButton.onclick = getBalance;
withdrawButton.onclick = withdraw;
