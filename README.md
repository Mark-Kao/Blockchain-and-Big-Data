# 🎲 DiceGame NFT 🎲

A fun, simple on-chain dice game built with Solidity and Foundry, where players pay ETH to roll a dice. The result earns them a small payout and mints a unique NFT representing their roll!

---

## 📂 Project Structure

```
DiceGameNFT/
├── foundry.toml                  # Foundry config file
├── README.md                     # Project documentation
├── lib/
│   └── openzeppelin-contracts/   # OpenZeppelin libraries (installed via Forge)
├── src/
│   └── DiceGame.sol              # Main contract
├── test/
│   └── DiceGame.t.sol            # Unit tests using Forge
└── script/
    └── Deploy.s.sol              # (optional deployment scripts)
```

---

## 📖 What This Project Does

- **Players call `play()`** by sending **0.004 ETH**
- The contract **randomly rolls a dice (1–6)**
- Players receive a payout based on their roll:  
  `result * 0.001 ether`
- A unique **NFT is minted to the player’s address**  
  with a result-specific metadata URI
- NFTs are viewable on **OpenSea (Sepolia Testnet)**

---

## ⚒️ Requirements

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Node.js + npm (optional for Remix / OpenZeppelin installs)
- MetaMask + Sepolia ETH for testing
- [Remix IDE](https://remix.ethereum.org/)

---

## 🧪 Local Development & Testing with Foundry

1. **Clone this repo**

```bash
git clone <repo-url>
cd Blockchain-and-Big-Data
```

2. **Install dependencies**

```bash
forge install OpenZeppelin/openzeppelin-contracts --no-commit
```

3. **Compile contracts**

```bash
forge build
```

4. **Run unit tests**

```bash
forge test
```

---

## 🚀 Deploy & Interact with Remix (Sepolia Testnet)

### 📦 Prepare Remix

1. Go to [Remix IDE](https://remix.ethereum.org/)
2. In the file explorer:
   - Copy your local `src/DiceGame.sol` into Remix.

3. **Import OpenZeppelin via direct URL (no plugin needed)**  
   Replace these lines:

```solidity
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
```

With:

```solidity
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.3.0/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.3.0/contracts/access/Ownable.sol";
```

4. **Compile the contract**
   - Solidity version: `^0.8.20`
   - In Remix:
     - Set **Compiler** version to `0.8.20`
     - Enable **Auto Compile**
     - Click **Compile DiceGame.sol**

---

### 📤 Deploy to Sepolia Testnet

1. In Remix, switch to the **Deploy & Run Transactions** tab.
2. Set **Environment** to `Injected Provider - MetaMask`
3. Connect your MetaMask wallet and switch to **Sepolia Testnet**
4. Deploy the `DiceGame` contract (no constructor parameters)

---

### 💸 Fund the Contract

Before playing, make sure the contract holds enough ETH for payouts:

- Copy your deployed contract address from Remix.
- Open MetaMask → **Send**
- Paste the contract address
- Send at least **0.01 ETH** (e.g. 0.02 ETH for multiple rolls)

> 💡 You can track contract balance anytime via [Sepolia Etherscan](https://sepolia.etherscan.io/)

---

### 🎮 Interact — Play the Game

1. In Remix’s **Deployed Contracts** section, expand your `DiceGame` contract.
2. In the **Value** field above the `play()` button:
   - Enter `0.004` ETH  
     (which is `4000000000000000` wei)
3. Click `play()`
4. Confirm the MetaMask transaction — the **estimated change you see is normal** (it estimates gas fees + ETH transferred, not final dice result).

5. After the transaction:
   - Check **Logs** in Remix Console for `DiceRolled` events
   - Verify payouts reflected in your wallet
   - Track contract balance and transaction logs via [Sepolia Etherscan](https://sepolia.etherscan.io/)

---

## 📜 View Minted NFTs on OpenSea (Sepolia Testnet)

Once your transaction is mined and OpenSea indexes it:

1. Go to [OpenSea Testnet (Sepolia)](https://testnets.opensea.io/)
2. Connect your MetaMask wallet
3. Click your **Profile**
4. Under **Collected NFTs**, you should see your newly minted NFT representing your dice roll.

> ⚠️ **Note:**  
The metadata URIs (`ipfs://dice-face-1`, etc.) are placeholders. Real images won’t display unless you replace them with valid hosted IPFS metadata and images via `setResultURI()`.

---

## 📊 Track Contract & Transaction Details

Monitor your deployed contract and its activities:

- Paste your contract address into [Sepolia Etherscan](https://sepolia.etherscan.io/)
- Track:
  - Contract balance
  - Player transactions
  - `DiceRolled` event logs
  - Contract source code and ABI (if verified)

---

## 🔄 Recover Remix Session & Manage Contract

### Recover Deployed Contract in Remix

If you close your browser or Remix tab:

1. Go to **Deploy & Run Transactions** panel
2. In the **At Address** field
3. Paste your previously deployed contract address
4. Click **At Address**  
Now you can interact with the contract again.

---

## 💸 Withdraw Contract Balance

After testing, reclaim your test ETH:

1. In Remix’s **Deployed Contracts** panel
2. Expand your deployed `DiceGame` contract
3. Click `withdrawAll()`
   - Only the contract **owner** can call this.

You’ll see the ETH transferred to your wallet, and can confirm via:
- Etherscan transaction log
- MetaMask balance

---

## ⚙️ Notes & Important Details

- **Randomness:**  
  The contract uses `block.prevrandao` for pseudo-random dice results.  
  ⚠️ This is **not secure for production or high-value games**.  
  Use [Chainlink VRF](https://docs.chain.link/vrf) for verifiable randomness in real-world deployments.

- **Estimated Changes in MetaMask:**  
  The amount shown before confirming `play()` includes estimated gas fees and the 0.004 ETH sent to the contract — not your dice result payout.

- **NFT Metadata:**  
  IPFS URIs (`ipfs://dice-face-1`, etc.) are placeholders.  
  Update them using the `setResultURI(uint8 result, string calldata uri)` function.

---

## 📊 DiceGame Contract Function Summary

| Function              | Description                                                   |
|:----------------------|:--------------------------------------------------------------|
| `play()`               | Rolls the dice, pays out ETH, mints an NFT                     |
| `randomDiceRoll()`     | Generates a pseudo-random dice result (1–6)                    |
| `_mintNFT()`           | Mints an ERC721 NFT with dice result metadata URI              |
| `setResultURI()`       | Updates IPFS metadata URI for a given dice result              |
| `setMinimumReserve()`  | Adjusts contract's minimum ETH reserve                         |
| `withdrawAll()`        | Allows owner to withdraw the entire contract balance           |

---

## 📦 Metadata URIs

Dice results are tied to IPFS URIs, configured as placeholders:

- `ipfs://dice-face-1`
- `ipfs://dice-face-2`
- ...
- `ipfs://dice-face-6`

You can update these URIs via the `setResultURI()` function.

---

## 📖 License

MIT © 2024  
Built for fun, practice, and testnet games 🎲✨