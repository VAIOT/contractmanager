import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const deployServiceAgreement: DeployFunction = async function (
  hre: HardhatRuntimeEnvironment
) {
  const { deployments, getNamedAccounts, network } = hre;
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  log("----------------------------------------------------");
  log("Deploying ServiceAgreement...");
  const serviceAgreement = await deploy("ServiceAgreement", {
    from: deployer,
    log: true,
  });

  log(`ServiceAgreement deployed at ${serviceAgreement.address}`);
};

export default deployServiceAgreement;
deployServiceAgreement.tags = ["all", "service_agreement"];
