# VoteDao

VoteDao is a smart contract that enables decentralized proposal creation and voting using a fair and innovative **quadratic voting mechanism**. Built on Solidity, it empowers users to express preferences more precisely than simple one-vote-per-person systems, all while staying fully on-chain and transparent.


## Smart Contract:

URL : https://scan.test2.btcs.network/tx/0x2801150f0b3c86b3d16f438646a5d500cb0905730fcf1489ba00307ac84243d7

Transaction hash : 0x2801150f0b3c86b3d16f438646a5d500cb0905730fcf1489ba00307ac84243d7

<img width="1470" alt="image" src="https://github.com/user-attachments/assets/c6577822-bc23-4ccc-ba54-5acb72698e0d" />




---

## 🔍 Overview

VoteDao allows any wallet address to:
- ✅ Create new proposals with a description and a voting deadline.
- 🗳️ Vote on proposals using voting **credits** allocated to their address.
- ⚖️ Use **quadratic voting**: the cost of N votes is N² credits, encouraging thoughtful voting.

---

## ✨ Features

| Feature                  | Description                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| 🆓 Open Participation     | Any wallet can create proposals and vote.                                   |
| 🧠 Quadratic Voting       | More votes cost exponentially more credits to promote fairness.             |
| 🕒 Time-Locked Proposals  | Voting is only allowed before each proposal’s deadline.                     |
| 🔐 Credit Allocation      | Every new wallet receives 100 voting credits upon first action.             |
| 🧾 Transparent History    | Proposal creation and voting events are emitted and can be tracked easily. |

---

## 📦 Contract Details

### Contract Name: `VoteDao`

- **Language:** Solidity `^0.8.0`
- **File:** `VoteDao.sol`
- **Contract Type:** DAO Voting Mechanism
- **Gas Optimized:** Yes (basic storage and control logic)

---

## 🛠️ Functions

### 🔹 `createProposal(string description, uint256 duration)`
Creates a new proposal with a specified duration (in seconds). Emits `ProposalCreated`.

**Params:**
- `description`: The text of the proposal.
- `duration`: How long the proposal will be open for voting (in seconds).

---

### 🔹 `castVote(uint256 proposalId, uint256 votes)`
Casts votes on a given proposal using the quadratic voting cost formula. Emits `VoteCast`.

**Logic:**
- Cost = NewVotes² - PreviousVotes²
- Cost is deducted from the caller’s voting credits.

---

### 🔹 `getProposal(uint256 proposalId)`
Returns a proposal's details (description, proposer, deadline, total votes).

---

## 📊 Quadratic Voting

Unlike linear voting (1 vote = 1 point), **quadratic voting** means:

| Votes Cast | Credits Cost |
|------------|--------------|
| 1          | 1            |
| 2          | 4            |
| 3          | 9            |
| 4          | 16           |

This ensures:
- More votes = more conviction
- Prevents whales from overpowering every decision cheaply

---

## 🔐 Voting Credits

- Each wallet gets **100 credits** upon their first proposal or vote.
- Credits are consumed as votes are cast.
- No external token needed – fully on-chain logic.

---

## 📦 Deployment (Hardhat)

```bash
git clone https://github.com/your-username/VoteDao.git
cd VoteDao
npm install

