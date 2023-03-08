// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TravelInsuranceFactory {
    address public manager; // our company's wallet address
    address[] public deployedInsurances;

    constructor() {
        manager = msg.sender;
    }

    function createTravelInsurance(
        address _insured,
        uint256 _tripStart,
        uint256 _tripEnd,
        uint256 _premium,
        uint256 _payoutAmount
        ) public {
        // create new contract
        // add to deployedInsurance

        TravelInsurance newInsurance = new TravelInsurance(
            manager,
            _insured,
            _tripStart,
            _tripEnd,
            _premium,
            _payoutAmount
        );
        deployedInsurances.push(newInsurance);
    }

    function getDeployedInsurance() public view returns (address[] memory) {
        return deployedInsurances;
    }
}


contract TravelInsurance {
    address public insurer; // our company's wallet address
    address public insured; // the person who buys the insurance
    uint256 public tripStart;
    uint256 public tripEnd;
    uint256 public premium; // price of the insurance
    uint256 public payoutAmount; // amount to be paid out to the purchaser once claimed
    bool public isActive;
    bool public isPaidOut;

    constructor(
        address _insurer,
        address _insured,
        uint256 _tripStart,
        uint256 _tripEnd,
        uint256 _premium,
        uint256 _payoutAmount
        ) {
        insurer = _insurer;
        insured = _insured;
        tripStart = _tripStart;
        tripEnd = _tripEnd;
        premium = _premium;
        payoutAmount = _payoutAmount;
        isActive = false;
        isPaidOut = false;
    }

    function payPremium() public payable {
        require(msg.value == premium); // Pay the premium of the insurance
        isActive = true; // onle when the premium is paid, the insurance is active
    }

    function cancelInsurance() public onlyInsurer {
        isActive = false;
    }

    function claimInsurance() public onlyInsurer {
        require(isActive); // can only claim when the insurance is active
        require(block.timestamp >= tripStart); // can only claim after the trip starts
        require(block.timestamp < tripEnd); // can only claim before the trip ends
        require(!isPaidOut); // can only claim once

        payable(purchaser).transfer(payoutAmount);
        isPaidOut = true;
    }

    modifier onlyInsurer() {
        require(msg.sender == insurer);
        _;
    }

    function getDetails() public view returns (
        address _insurer,
        address _insured,
        uint256 _tripStart,
        uint256 _tripEnd,
        uint256 _premium,
        uint256 _payoutAmount,
        bool _isActive,
        bool _isPaidOut
    ) {
        return (
            insurer,
            insured,
            tripStart,
            tripEnd,
            premium,
            payoutAmount,
            isActive,
            isPaidOut
        );
    }
}