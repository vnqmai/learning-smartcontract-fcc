// mocha framework
// const { ethers } = require("hardhat");
// const { expect, assert } = require("chai");
import { assert } from "chai";
import { ethers } from "hardhat";
import { SimpleStorage__factory } from "./../typechain-types/factories/SimpleStorage__factory";
import { SimpleStorage } from "./../typechain-types/SimpleStorage";

describe("SimpleStorage", () => {
  let simpleStorageFactory: SimpleStorage__factory;
  let simpleStorage: SimpleStorage;
  beforeEach(async () => {
    simpleStorageFactory = (await ethers.getContractFactory(
      "SimpleStorage"
    )) as SimpleStorage__factory;
    simpleStorage = await simpleStorageFactory.deploy();
  });

  it("Should start with a favorite number of 123", async () => {
    const currentValue = await simpleStorage.retrieve();
    const expectedValue = "123";
    // assert
    // expect
    assert.equal(currentValue.toString(), expectedValue);
    // expect(currentValue.toString().to.equal(expectedValue));
  });

  it("Should update when we call store", async () => {
    const expectedValue = "7";
    const transactionResponse = await simpleStorage.store(expectedValue);
    await transactionResponse.wait(1);

    const currentValue = await simpleStorage.retrieve();
    assert.equal(currentValue.toString(), expectedValue);
  });
});
