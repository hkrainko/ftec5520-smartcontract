// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TravelInsuranceFactory {
    address public manager;
    address[] public deployedInsurance;

    enum InsuranceType{ PlanA, PlanB, PlanC }

    constructor() {
        manager = msg.sender;
    }

    function createTravelInsurance(InsuranceType insuranceType) public {
        // create new contract
        // add to deployedInsurance

        TravelInsurance newInsurance = new TravelInsurance();
        deployedInsurance.push(newInsurance);
    }

    function getDeployedInsurance() public view returns (address[] memory) {
        return deployedInsurance;
    }
}


contract TravelInsurance {
    address public manager;
    address public purchaser;

    constructor(address manager, address purchaser) {
        manager = manager;
        purchaser = purchaser;
    }

    function pickWinner() public restricted {
        // require(msg.sender == manager); // no need to use if use restricted

        uint index = random() % players.length;
        players[index].transfer(this.balance); // this = instance of the current contract, balance = money of the currency contract
        players = new address[](0); //dynamic array with initial size of 0
    }

    // function returnEntries() {
    //     require(msg.sender == manager); // repeated code
    // }

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function getPlayers() public view returns (address[]) {
        return players;
    }
}