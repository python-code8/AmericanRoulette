// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";


 
contract AmericanRoulette is VRFConsumerBase {
    
   
    bytes32 internal keyHash;
    uint256 internal fee;
    address owner;
    uint256 public randomResult;
    uint256 public contractBalance;
    event OutCome(address player, uint _betAmount, bool result, string gametype);
    event Funded(address funder, uint amount);
    event Withdrawed(address receiver, uint amount);
    event OwnershipChanged(address from, address _to);
 
    constructor(

        address _vrfcoordinator,
        address _linktoken,
        bytes32 _keyhash,
        uint256 _fee
    ) 
    public VRFConsumerBase(
        _vrfcoordinator,
        _linktoken
    )
    {
        keyHash = _keyhash;
        fee =  _fee;
        owner = msg.sender;
    }
    

    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee);
    }


    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
    }

    function InsideBet(uint num, uint betAmount) public payable {
        require(num <= 0, "Enter a positive and non-zero");
        require(contractBalance > (betAmount * 17), "Insufficient balance in contract");
        if ((randomResult % 37) == num) {
            uint reward = betAmount + betAmount * (num.div(2)); 
            contractBalance -= reward;
            payable(msg.sender).transfer(reward);
            emit OutCome(msg.sender, betAmount, true, "Inside Bet 1 to 36");
        }
        else {
            contractBalance += betAmount;
            emit OutCome(msg.sender, betAmount, false, "Inside Bet 1 to 36");
        }
    }

    function BlackOrRed(uint choice, uint betAmount) public payable {
        
        require(contractBalance > (betAmount * 2), "Insufficient balance in contract");
        if ((randomResult % 2) == choice) {
            uint reward = betAmount.mul(2);
            contractBalance -= reward;
            payable(msg.sender).transfer(reward);
            emit OutCome(msg.sender, betAmount, true, "Black or Red");
        }
        else {
            contractBalance += betAmount;
            emit OutCome(msg.sender, betAmount, false, "Black or Red");
        }
    }

    function OddOrEven(uint choice, uint betAmount) public payable {
        
        require(contractBalance > (betAmount * 2), "Insufficient balance in contract");
        if ((randomResult % 2) == choice) {
            uint reward = betAmount.mul(2);
            contractBalance -= reward;
            payable(msg.sender).transfer(reward);
            emit OutCome(msg.sender, betAmount, true, "Odd or Even");
        }
        else {
            contractBalance += betAmount;
            emit OutCome(msg.sender, betAmount, false, "Odd or Even");
        }
    }

    function HighOrLow(uint choice, uint betAmount) public payable {
       
        require(contractBalance > (betAmount * 2), "Insufficient balance in contract");
        if ((randomResult % 2) == choice) {
            uint reward = betAmount.mul(2);
            contractBalance -= reward;
            payable(msg.sender).transfer(reward);
            emit OutCome(msg.sender, betAmount, true, "High or Low");
        }
        else {
            contractBalance += betAmount;
            emit OutCome(msg.sender, betAmount, false, "High or Low");
        }
    }

    function ColumnBet(uint columnNumber, uint betAmount) public payable {
        
        require(contractBalance > (betAmount * 3), "Insufficient balance in contract");
        if(columnNumber == 1) {
            for (uint i = 1; i < 37; i = i + 3) {
                if (i == randomResult) {
                    uint reward = betAmount.mul(3);
                    contractBalance -= reward;
                    payable(msg.sender).transfer(reward);
                    emit OutCome(msg.sender, betAmount, true, "Column Bet");
                }
                else {
                    contractBalance += betAmount;
                    emit OutCome(msg.sender, betAmount, false, "Column Bet");
                }
            }
        }
        else if (columnNumber == 2) {
            for (uint i = 2; i < 37; i = i + 3) {
                if (i == randomResult) {
                    uint reward = betAmount.mul(3);
                    contractBalance -= reward;
                    payable(msg.sender).transfer(reward);
                    emit OutCome(msg.sender, betAmount, true, "Column Bet");
                }
                else {
                    contractBalance += betAmount;
                    emit OutCome(msg.sender, betAmount, false, "Column Bet");
                }
            }
        }
        else if (columnNumber == 3) {
            for (uint i = 3; i < 37; i = i + 3) {
                if (i == randomResult) {
                    uint reward = betAmount.mul(3);
                    contractBalance -= reward;
                    payable(msg.sender).transfer(reward);
                    emit OutCome(msg.sender, betAmount, true, "Column Bet");
                }
                else {
                    contractBalance += betAmount;
                    emit OutCome(msg.sender, betAmount, false, "Column Bet");
                }
            }
        }
    }

    function dozenBet(uint rowRange, uint betAmount) public payable {
        
        require(contractBalance > (betAmount * 3), "Insufficient balance in contract");
        if (rowRange == 1) {
            for (uint i = 1; i <= 12; i += 1) {
                if (i == randomResult) {
                    uint reward = betAmount.mul(3);
                    contractBalance -= reward;
                    payable(msg.sender).transfer(reward);
                    emit OutCome(msg.sender, betAmount, true, "Dozen Bet");
                }
                else {
                    contractBalance += betAmount;
                    emit OutCome(msg.sender, betAmount, false, "Dozen Bet");
                }
            }
        }
        else if (rowRange == 2) {
            for (uint i = 13; i <= 24; i += 1) {
                if (i == randomResult) {
                    uint reward = betAmount.mul(3);
                    contractBalance -= reward;
                    payable(msg.sender).transfer(reward);
                    emit OutCome(msg.sender, betAmount, true, "Dozen Bet");
                }
                else {
                    contractBalance += betAmount;
                    emit OutCome(msg.sender, betAmount, false, "Dozen Bet");
                }
            }
        }
        else if (rowRange == 3) {
            for (uint i = 25; i <= 36; i += 1) {
                if (i == randomResult) {
                    uint reward = betAmount.mul(3);
                    contractBalance -= reward;
                    payable(msg.sender).transfer(reward);
                    emit OutCome(msg.sender, betAmount, true, "Dozen Bet");
                }
                else {
                    contractBalance += betAmount;
                    emit OutCome(msg.sender, betAmount, false, "Dozen Bet");
                }
            }
        }

    }

    function fundContract() public payable {
        require(msg.sender == owner, "You don't have access");
        contractBalance = contractBalance.add(msg.value);
        emit Funded(msg.sender, msg.value);
    }

    function withdraw() public payable {
        require(msg.sender == owner, "You don't have access");
        uint _balance = address(this).balance;
        contractBalance = 0;
        payable(msg.sender).transfer(_balance);
        emit Withdrawed(msg.sender, _balance);

    }

    function changeOwner(address _to) public payable {
        require(msg.sender == owner, "You don't have access");
        owner = _to;
        emit OwnershipChanged(msg.sender, _to);
    }    
    
    
}
