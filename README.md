<div align="center">
    <img src="assets/vaiotLogo.svg" alt="VAIOT Logo" width="400"/>
</div>

</br>
</br>

# VAIOT Contract Manager

Welcome to the official repository for VAIOT's Contract Manager. This repository is dedicated to the development and maintenance of the contract manager using the Hardhat development environment, tailored for the Ethereum ecosystem.

## Installation

Begin by cloning the repository and installing the necessary dependencies:

```bash
git clone https://github.com/VAIOT/contractmanager.git
cd contractmanager
npm install
```

## Configuration

To properly configure the project, create a .env file in the root directory and include the following required variables:

```bash
MUMBAI_RPC_URL= # RPC URL for the Mumbai testnet
GOERLI_RPC_URL= # RPC URL for the Goerli testnet
PRIVATE_KEY= # Private key for contract deployment
COINMARKETCAP_API_KEY= # CoinMarketCap API key
POLYGONSCAN_API_KEY= # PolygonScan API key
REPORT_GAS= # true or false
ETHERSCAN_API_KEY= # Etherscan API key
POLYGONEDGE_RPC_URL= # RPC URL for PolygonEdge
KALEIDO_AUTHORIZATION= # Kaleido Authorization Key

```

## Smart Contract Overview

The ContractManager allows users to save, update and delete contracts following a specified format.

<ul>
    <li>Users can create their own contracts, that follow specific criteria.</li>
    <li>Existing contracts can be later on updated, or deleted.</li>
    <li>The ownership of the smart contract can be transferred to a third-party.</li>
    <li>There are a number of getter functions in place for easy user experience.</li>
</ul>

Refer to the source code for detailed information on each function.

## Deployment

Deploy the smart contract either locally or on the Mumbai testnet using the Hardhat tool.

### Local Deployment

```bash
npx hardhat deploy
```

### Mumbai Testnet Deployment

```bash
npx hardhat deploy --network mumbai
```

## Testing

Run the unit tests to ensure code reliability:

```bash
npx hardhat test
```

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated.
