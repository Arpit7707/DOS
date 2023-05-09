// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Good {
    address public currentWinner;
    uint public currentAuctionPrice;

    constructor() {
        currentWinner = msg.sender;
    }

    function setCurrentAuctionPrice() public payable {
        require(msg.value > currentAuctionPrice, "Need to pay more than the currentAuctionPrice");
        (bool sent, ) = currentWinner.call{value: currentAuctionPrice}("");
        if (sent) {
            currentAuctionPrice = msg.value;
            currentWinner = msg.sender;
        }
    }
}

//when another user apart from attcak.sol tries to be the winner, it won't happen. 
//Because, Good.sol updates current winner only if the ETH is sent to previous winner. 
//And as Attack.sol doesn't contain fallback(), it will not accept the ETH back and Attack.sol will remain the winner permanentley. 

//Prevention of DOS :

// contract Good {
//     address public currentWinner;
//     uint public currentAuctionPrice;
//     mapping(address => uint) public balances;

//     constructor() {
//         currentWinner = msg.sender;
//     }

//     function setCurrentAuctionPrice() public payable {
//         require(msg.value > currentAuctionPrice, "Need to pay more than the currentAuctionPrice");
//         balances[currentWinner] += currentAuctionPrice;
//         currentAuctionPrice = msg.value;
//         currentWinner = msg.sender;
//     }

//     function withdraw() public {
//         require(msg.sender != currentWinner, "Current winner cannot withdraw");

//         uint amount = balances[msg.sender];
//         balances[msg.sender] = 0;

//         (bool sent, ) = msg.sender.call{value: amount}("");
//         require(sent, "Failed to send Ether");
//     }
// }