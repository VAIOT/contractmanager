import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const deployNDAManager: DeployFunction = async function (
  hre: HardhatRuntimeEnvironment
) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  log("----------------------------------------------------");
  log("Deploying NDAManager and waiting for confirmations...");

  const ndaManager = await deploy("NDAManager", {
    from: deployer,
    args: [],
    log: true,
  });

  log(`NDAManager deployed at ${ndaManager.address}`);
};

export default deployNDAManager;
deployNDAManager.tags = ["all", "nda_manager"];
