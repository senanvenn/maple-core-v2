// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.7;

import { IFixedTermLoanManager, ILoanLike } from "../../contracts/interfaces/Interfaces.sol";

import { Address } from "../../contracts/Contracts.sol";

import { TestBaseWithAssertions } from "../TestBaseWithAssertions.sol";

contract FinishCollateralLiquidationFailureTests is TestBaseWithAssertions {

    address loan;

    function setUp() public virtual override {
        super.setUp();

        depositLiquidity(address(new Address()), 1_500_000e6);

        setupFees({
            delegateOriginationFee:     500e6,
            delegateServiceFee:         275e6,
            delegateManagementFeeRate:  0.02e6,
            platformOriginationFeeRate: 0.001e6,
            platformServiceFeeRate:     0.0066e6,
            platformManagementFeeRate:  0.08e6
        });

        loan = fundAndDrawdownLoan({
            borrower:    address(new Address()),
            termDetails: [uint256(5 days), uint256(30 days), uint256(3)],
            amounts:     [uint256(100e18), uint256(1_000_000e6), uint256(1_000_000e6)],
            rates:       [uint256(0.075e18), uint256(0), uint256(0), uint256(0)],
            loanManager: poolManager.loanManagerList(0)
        });
    }

    function test_finishCollateralLiquidation_notAuthorized() external {
        vm.expectRevert("PM:FCL:NOT_AUTHORIZED");
        poolManager.finishCollateralLiquidation(loan);
    }

    function test_finishCollateralLiquidation_notPoolManager() external {
        IFixedTermLoanManager loanManager = IFixedTermLoanManager(ILoanLike(loan).lender());

        vm.prank(address(1));
        vm.expectRevert("LM:FCL:NOT_PM");
        loanManager.finishCollateralLiquidation(loan);
    }

    function test_finishCollateralLiquidation_notFinished() external {
        // Warp to end of grace period and initiate liquidation.
        vm.warp(start + 30 days + 5 days + 1);

        triggerDefault(loan, address(liquidatorFactory));

        vm.prank(address(poolDelegate));
        vm.expectRevert("LM:FCL:LIQ_ACTIVE");
        poolManager.finishCollateralLiquidation(loan);
    }

}
