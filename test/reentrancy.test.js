const {loadFixture} = require("@nomicfoundation/hardhat-network-helpers");
const {ethers} = require("hardhat");
const {expect} = require("chai");

describe("Reentrancy attack test", function () {
    async function setupRentrancy () {
        const reentrancyContractFactory = await ethers.getContractFactory("Reentrancy");
        const attackerContractFactory = await ethers.getContractFactory("Attacker");

        const reentrancyContract = await reentrancyContractFactory.deploy();
        const attackerContract = await attackerContractFactory.deploy(reentrancyContract.address);

        let [acc1] = await ethers.getSigners();

        return {reentrancyContract, attackerContract, acc1}
    }
    async function setupRentrancyFixed () {
        const reentrancyContractFactory = await ethers.getContractFactory("ReentrancyFixed");
        const attackerContractFactory = await ethers.getContractFactory("Attacker");

        const reentrancyContract = await reentrancyContractFactory.deploy();
        const attackerContract = await attackerContractFactory.deploy(reentrancyContract.address);

        let [acc1] = await ethers.getSigners();

        return {reentrancyContract, attackerContract, acc1}
    }
    async function setupRentrancyFixedWithGuard() {
        const reentrancyContractFactory = await ethers.getContractFactory("ReentrancyFixedLock");
        const attackerContractFactory = await ethers.getContractFactory("Attacker");

        const reentrancyContract = await reentrancyContractFactory.deploy();
        const attackerContract = await attackerContractFactory.deploy(reentrancyContract.address);

        let [acc1] = await ethers.getSigners();

        return {reentrancyContract, attackerContract, acc1}
    }

    it("Should successfully attack reentrancy contract", async function(){
        const {reentrancyContract, attackerContract, acc1} = await loadFixture(setupRentrancy);

        const amount = ethers.utils.parseEther("10");

        await reentrancyContract.connect(acc1).deposit({value: amount});

        expect(await ethers.provider.getBalance(reentrancyContract.address)).to.equal(amount);

        const baitAmount = ethers.utils.parseEther("1");
        await attackerContract.deposit({value: baitAmount});

        expect(await ethers.provider.getBalance(reentrancyContract.address)).to.equal(0);

    })
    
    it("Should fail reentrancy attack contract", async function(){
        const {reentrancyContract, attackerContract, acc1} = await loadFixture(setupRentrancyFixed);

        const amount = ethers.utils.parseEther("10");

        await reentrancyContract.connect(acc1).deposit({value: amount});

        expect(await ethers.provider.getBalance(reentrancyContract.address)).to.equal(amount);

        const baitAmount = ethers.utils.parseEther("1");

        await expect(attackerContract.deposit({value: baitAmount})).to.reverted;

    })

    it("Should fail reentrancy attack with rentrancy gaurd", async function(){
        const {reentrancyContract, attackerContract, acc1} = await loadFixture(setupRentrancyFixedWithGuard);

        const amount = ethers.utils.parseEther("10");

        await reentrancyContract.connect(acc1).deposit({value: amount});

        expect(await ethers.provider.getBalance(reentrancyContract.address)).to.equal(amount);

        const baitAmount = ethers.utils.parseEther("1");

        await expect(attackerContract.deposit({value: baitAmount})).to.reverted;

    })
})