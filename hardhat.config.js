require("@nomicfoundation/hardhat-toolbox");

// The next line is part of the sample project, you don't need it in your
// project. It imports a Hardhat task definition, that can be used for
// testing the frontend.
require("./tasks/faucet");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.4",
  networks: {
    hardhat: {
      chainId: 1337, // We set 1337 to make interacting with MetaMask simpler
    },
    goerli: {
      url: "https://still-virulent-smoke.ethereum-goerli.quiknode.pro/54f4793cc9515651e2a0764d9019334fe0619d4b",
      accounts: [
        "d062537f804ac2b4f36529e8c9035b456bbcc5b6797917082a06ba84ea00007e",
      ],
      saveDeployments: true,
      chainId: 5,
    },
  },
};
