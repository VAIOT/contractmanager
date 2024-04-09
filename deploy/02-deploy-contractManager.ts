import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const deployContractManager: DeployFunction = async function (
  hre: HardhatRuntimeEnvironment
) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  log("----------------------------------------------------");
  log("Deploying Contract Manager and waiting for confirmations...");

  const contractManager = await deploy("ContractManager", {
    from: deployer,
    args: [],
    log: true,
  });

  log(`Contract Manager deployed at ${contractManager.address}`);
};

export default deployContractManager;
deployContractManager.tags = ["all", "contract_manager"];
