// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.7;

import { console2 as console, Script } from "../modules/forge-std/src/Script.sol";

import { NonTransparentProxy } from "../modules/globals/modules/non-transparent-proxy/contracts/NonTransparentProxy.sol";

import { LoanManagerFactory as FixedTermLoanManagerFactory } from "../modules/fixed-term-loan-manager/contracts/proxy/LoanManagerFactory.sol";
import { LoanManager as FixedTermLoanManagerImplementation } from "../modules/fixed-term-loan-manager/contracts/LoanManager.sol";
import { LoanManagerInitializer as FixedTermLoanManagerInitializer } from "../modules/fixed-term-loan-manager/contracts/proxy/LoanManagerInitializer.sol";

import { MapleLoanFactory as FixedTermLoanFactory } from "../modules/fixed-term-loan/contracts/MapleLoanFactory.sol";
import { MapleLoan as FixedTermLoanImplementation } from "../modules/fixed-term-loan/contracts/MapleLoan.sol";
import { MapleLoanInitializer as FixedTermLoanInitializer } from "../modules/fixed-term-loan/contracts/MapleLoanInitializer.sol";
import { MapleRefinancer as FixedTermRefinancer } from "../modules/fixed-term-loan/contracts/MapleRefinancer.sol";

import { LoanManagerFactory as OpenTermLoanManagerFactory } from "../modules/open-term-loan-manager/contracts/LoanManagerFactory.sol";
import { LoanManager as OpenTermLoanManagerImplementation } from "../modules/open-term-loan-manager/contracts/LoanManager.sol";
import { LoanManagerInitializer as OpenTermLoanManagerInitializer } from "../modules/open-term-loan-manager/contracts/LoanManagerInitializer.sol";

import { MapleLoanFactory as OpenTermLoanFactory } from "../modules/open-term-loan/contracts/MapleLoanFactory.sol";
import { MapleLoan as OpenTermLoanImplementation } from "../modules/open-term-loan/contracts/MapleLoan.sol";
import { MapleLoanInitializer as OpenTermLoanInitializer } from "../modules/open-term-loan/contracts/MapleLoanInitializer.sol";
import { MapleRefinancer as OpenTermRefinancer } from "../modules/open-term-loan/contracts/MapleRefinancer.sol";

import { MapleGlobals as Globals } from "../modules/globals/contracts/MapleGlobals.sol";

import { MaplePoolManagerFactory as PoolManagerFactory } from "../modules/pool/contracts/proxy/MaplePoolManagerFactory.sol";
import { MaplePoolManager as PoolManager } from "../modules/pool/contracts/MaplePoolManager.sol";
import { MaplePoolDeployer as PoolDeployer } from "../modules/pool/contracts/MaplePoolDeployer.sol";
import { MaplePoolManagerInitializer as PoolManagerInitializer } from "../modules/pool/contracts/proxy/MaplePoolManagerInitializer.sol";

import { NonTransparentProxy as PoolPermissionManagerProxy } from "../modules/pool-permission-manager/modules/ntp/contracts/NonTransparentProxy.sol";
import { MaplePoolPermissionManager as PoolPermissionManager } from "../modules/pool-permission-manager/contracts/MaplePoolPermissionManager.sol";
import { MaplePoolPermissionManagerInitializer as PoolPermissionManagerInitializer } from "../modules/pool-permission-manager/contracts/proxy/MaplePoolPermissionManagerInitializer.sol";

import { MapleWithdrawalManagerFactory as WithdrawalManagerCyclicalFactory } from "../modules/withdrawal-manager-cyclical/contracts/MapleWithdrawalManagerFactory.sol";
import { MapleWithdrawalManager as WithdrawalManagerCyclical } from "../modules/withdrawal-manager-cyclical/contracts/MapleWithdrawalManager.sol";
import { MapleWithdrawalManagerInitializer as WithdrawalManagerCyclicalInitializer } from "../modules/withdrawal-manager-cyclical/contracts/MapleWithdrawalManagerInitializer.sol";

import { MapleWithdrawalManagerFactory as WithdrawalManagerQueueFactory } from "../modules/withdrawal-manager-queue/contracts/proxy/MapleWithdrawalManagerFactory.sol";
import { MapleWithdrawalManager as WithdrawalManagerQueue } from "../modules/withdrawal-manager-queue/contracts/MapleWithdrawalManager.sol";
import { MapleWithdrawalManagerInitializer as WithdrawalManagerQueueInitializer } from "../modules/withdrawal-manager-queue/contracts/proxy/MapleWithdrawalManagerInitializer.sol";

import { LiquidatorFactory } from "../modules/liquidations/contracts/LiquidatorFactory.sol";
import { Liquidator } from "../modules/liquidations/contracts/Liquidator.sol";
import { LiquidatorInitializer } from "../modules/liquidations/contracts/LiquidatorInitializer.sol";

import { ERC20 } from "../modules/erc20/contracts/ERC20.sol";

contract DeployMapleFinance is Script {
    address public deployer;
    address public globals;
    address public poolDeployer;
    
    // Factory contracts
    PoolManagerFactory public poolManagerFactory;
    FixedTermLoanManagerFactory public fixedTermLoanManagerFactory;
    OpenTermLoanManagerFactory public openTermLoanManagerFactory;
    FixedTermLoanFactory public fixedTermLoanFactory;
    OpenTermLoanFactory public openTermLoanFactory;
    WithdrawalManagerCyclicalFactory public withdrawalManagerCyclicalFactory;
    WithdrawalManagerQueueFactory public withdrawalManagerQueueFactory;
    LiquidatorFactory public liquidatorFactory;
    
    // Implementation addresses
    address public poolManagerImplementation;
    address public fixedTermLoanImplementation;
    address public openTermLoanImplementation;
    address public withdrawalManagerCyclicalImplementation;
    address public withdrawalManagerQueueImplementation;
    address public liquidatorImplementation;
    address public poolPermissionManagerImplementation;
    
    // Initializer addresses
    address public poolManagerInitializer;
    address public fixedTermLoanInitializer;
    address public openTermLoanInitializer;
    address public withdrawalManagerCyclicalInitializer;
    address public withdrawalManagerQueueInitializer;
    address public liquidatorInitializer;
    address public poolPermissionManagerInitializer;
    
    // Other addresses
    address public poolPermissionManager;
    address public fixedTermRefinancer;
    address public openTermRefinancer;
    ERC20 public testToken;

    function run() external {
        deployer = vm.envAddress("DEPLOYER");
        vm.startBroadcast(deployer);

        deployGlobals();
        deployPoolDeployer();
        deployFactories();
        deployImplementations();
        deployInitializers();
        deployOtherContracts();
        deployTestToken();
        configureGlobals();
        registerImplementations();
        setValidInstances();
        setDeploymentPermissions();

        vm.stopBroadcast();
    }

    function deployGlobals() internal {
        address globalsImplementation = address(new Globals());
        globals = address(new NonTransparentProxy(deployer, globalsImplementation));
    }

    function deployPoolDeployer() internal {
        poolDeployer = address(new PoolDeployer(globals));
    }

    function deployFactories() internal {
        poolManagerFactory = new PoolManagerFactory(globals);
        fixedTermLoanManagerFactory = new FixedTermLoanManagerFactory(globals);
        openTermLoanManagerFactory = new OpenTermLoanManagerFactory(globals);
        fixedTermLoanFactory = new FixedTermLoanFactory(globals, address(0));
        openTermLoanFactory = new OpenTermLoanFactory(globals);
        withdrawalManagerCyclicalFactory = new WithdrawalManagerCyclicalFactory(globals);
        withdrawalManagerQueueFactory = new WithdrawalManagerQueueFactory(globals);
        liquidatorFactory = new LiquidatorFactory(globals);
    }

    function deployImplementations() internal {
        poolManagerImplementation = address(new PoolManager());
        fixedTermLoanImplementation = address(new FixedTermLoanImplementation());
        openTermLoanImplementation = address(new OpenTermLoanImplementation());
        withdrawalManagerCyclicalImplementation = address(new WithdrawalManagerCyclical());
        withdrawalManagerQueueImplementation = address(new WithdrawalManagerQueue());
        liquidatorImplementation = address(new Liquidator());
        poolPermissionManagerImplementation = address(new PoolPermissionManager());
    }

    function deployInitializers() internal {
        poolManagerInitializer = address(new PoolManagerInitializer());
        fixedTermLoanInitializer = address(new FixedTermLoanInitializer());
        openTermLoanInitializer = address(new OpenTermLoanInitializer());
        withdrawalManagerCyclicalInitializer = address(new WithdrawalManagerCyclicalInitializer());
        withdrawalManagerQueueInitializer = address(new WithdrawalManagerQueueInitializer());
        liquidatorInitializer = address(new LiquidatorInitializer());
        poolPermissionManagerInitializer = address(new PoolPermissionManagerInitializer());
    }

    function deployOtherContracts() internal {
        poolPermissionManager = address(new PoolPermissionManagerProxy(deployer, poolPermissionManagerInitializer));
        fixedTermRefinancer = address(new FixedTermRefinancer());
        openTermRefinancer = address(new OpenTermRefinancer());
    }

    function deployTestToken() internal {
        testToken = new ERC20("Test", "TEST", 18);
    }

    function configureGlobals() internal {
        Globals(globals).setMapleTreasury(deployer);
        Globals(globals).setMigrationAdmin(deployer);
        Globals(globals).setSecurityAdmin(deployer);
        Globals(globals).setOperationalAdmin(deployer);
        Globals(globals).setValidPoolAsset(address(testToken), true);
        Globals(globals).setManualOverridePrice(address(testToken), 1e18);
        Globals(globals).setDefaultTimelockParameters(1 weeks, 2 days);
    }

    function registerImplementations() internal {
        poolManagerFactory.registerImplementation(100, poolManagerImplementation, poolManagerInitializer);
        poolManagerFactory.setDefaultVersion(100);

        fixedTermLoanFactory.registerImplementation(100, fixedTermLoanImplementation, fixedTermLoanInitializer);
        fixedTermLoanFactory.setDefaultVersion(100);

        openTermLoanManagerFactory.registerImplementation(100, openTermLoanImplementation, openTermLoanInitializer);
        openTermLoanManagerFactory.setDefaultVersion(100);

        withdrawalManagerCyclicalFactory.registerImplementation(100, withdrawalManagerCyclicalImplementation, withdrawalManagerCyclicalInitializer);
        withdrawalManagerCyclicalFactory.setDefaultVersion(100);

        withdrawalManagerQueueFactory.registerImplementation(100, withdrawalManagerQueueImplementation, withdrawalManagerQueueInitializer);
        withdrawalManagerQueueFactory.setDefaultVersion(100);

        liquidatorFactory.registerImplementation(100, liquidatorImplementation, liquidatorInitializer);
        liquidatorFactory.setDefaultVersion(100);
    }

    function setValidInstances() internal {
        Globals(globals).setValidInstanceOf("POOL_PERMISSION_MANAGER", poolPermissionManager, true);
        Globals(globals).setValidInstanceOf("LIQUIDATOR_FACTORY", address(liquidatorFactory), true);
        Globals(globals).setValidInstanceOf("POOL_MANAGER_FACTORY", address(poolManagerFactory), true);
        Globals(globals).setValidInstanceOf("WITHDRAWAL_MANAGER_CYCLE_FACTORY", address(withdrawalManagerCyclicalFactory), true);
        Globals(globals).setValidInstanceOf("WITHDRAWAL_MANAGER_QUEUE_FACTORY", address(withdrawalManagerQueueFactory), true);
        Globals(globals).setValidInstanceOf("FT_LOAN_FACTORY", address(fixedTermLoanFactory), true);
        Globals(globals).setValidInstanceOf("OT_LOAN_FACTORY", address(openTermLoanFactory), true);
        Globals(globals).setValidInstanceOf("LOAN_FACTORY", address(fixedTermLoanFactory), true);
        Globals(globals).setValidInstanceOf("LOAN_FACTORY", address(openTermLoanFactory), true);
        Globals(globals).setValidInstanceOf("FT_LOAN_MANAGER_FACTORY", address(fixedTermLoanManagerFactory), true);
        Globals(globals).setValidInstanceOf("OT_LOAN_MANAGER_FACTORY", address(openTermLoanManagerFactory), true);
        Globals(globals).setValidInstanceOf("LOAN_MANAGER_FACTORY", address(fixedTermLoanManagerFactory), true);
        Globals(globals).setValidInstanceOf("LOAN_MANAGER_FACTORY", address(openTermLoanManagerFactory), true);
        Globals(globals).setValidInstanceOf("FT_REFINANCER", fixedTermRefinancer, true);
        Globals(globals).setValidInstanceOf("REFINANCER", fixedTermRefinancer, true);
        Globals(globals).setValidInstanceOf("OT_REFINANCER", openTermRefinancer, true);
        Globals(globals).setValidInstanceOf("REFINANCER", openTermRefinancer, true);
        Globals(globals).setValidInstanceOf("POOL_PERMISSION_MANAGER", poolPermissionManager, true);
    }

    function setDeploymentPermissions() internal {
        Globals(globals).setCanDeployFrom(address(poolManagerFactory), poolDeployer, true);
        Globals(globals).setCanDeployFrom(address(withdrawalManagerCyclicalFactory), poolDeployer, true);
        Globals(globals).setCanDeployFrom(address(withdrawalManagerQueueFactory), poolDeployer, true);
    }
}