# Reentrancy Attack
This repo consist of various contracts to test and prevent reentrancy attack
- reentrancy.sol : This contract is suceptible to reentrancy attack
- reentrancy-fixed.sol: This contract update balance before transfering eth/tokens
- reentrancy-fixed-lock: This contract uses reentrancy gaurd lock to prevent reentrancy attack

#### testing
Run `npx hardhat test` to run contract test