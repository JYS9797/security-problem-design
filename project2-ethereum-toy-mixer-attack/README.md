# Project 2 — Attacking an Ethereum Toy Mixer Smart Contract

This repository contains a **security lab designed as a teaching assistant**
for an Information Security course.

The goal of this project is to demonstrate how **improper cryptographic design
in Ethereum mixing services** can lead to **fund theft**, even when a mixer is
intended to provide anonymity.

This is a *problem-design repository*, not a solution repository.

---

## Background

Mixing services attempt to break the on-chain linkability between deposits and
withdrawals by pooling funds and allowing delayed withdrawals.

In this project, a simplified **Ethereum Toy Mixer** is used:

- Users deposit ETH along with a *mixing hash*
- The contract later allows withdrawals by verifying the preimage of the hash
- A custom hash function (`toyhash`) is used instead of a secure commitment scheme

Design flaws in this construction allow an attacker to:
- Link deposits and withdrawals
- Forge a withdrawal transaction
- Steal funds belonging to another user

---

## Given Artifacts

- `src/toymixer.sol`  
  Vulnerable Ethereum mixing smart contract.

- `src/toyhash.py`  
  Reference Python implementation of the custom hash function used by the mixer.

- Ethereum testnet data (Sepolia):
  - Mixer contract address
  - Deposit transaction hashes (`d1`, `d2`)
  - Preimage components leaked to the attacker (salt, receiving address)

---

## Tasks

### Task 1 — Deposit–Withdrawal Linking
Identify the withdrawal transaction `w1` that corresponds to a given deposit
transaction `d1` by analyzing on-chain transaction data.

---

### Task 2 — Forged Withdrawal Construction
Given partial preimage information leaked from an external breach, construct
a withdrawal transaction `w2` that successfully steals ETH deposited by another
user.

Students must:
- Reconstruct the correct `toyhash` input
- Construct valid calldata for the `withdraw()` function
- Ensure the ETH amount and parameters satisfy the contract checks

---

## Learning Objectives

- Understand anonymity limitations of naive Ethereum mixers
- Analyze smart contract authentication logic
- Reason about cryptographic commitment misuse
- Construct real-world Ethereum attack transactions

---

## Solution Policy

To preserve academic integrity and allow reuse of this lab,
**complete solution code is intentionally not included**.

This repository focuses on **problem design and learning objectives**.

---

## Disclaimer

This project is for **educational purposes only** and demonstrates
security weaknesses in intentionally vulnerable smart contracts.
