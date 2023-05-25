//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;
contract Lottery{
    address public manager;
    address payable[] public participant;
    //-------> when we need to transfer some amount from smart contract
    //------> we need to make that account payable

    constructor (){
        manager=msg.sender; //------>controller of the contract
    } 

    receive() external payable
    {   require (msg.value==1 ether);
        participant.push(payable(msg.sender));
        //----> Every participant will pay to register itself
    }

    function getBalance() public view returns(uint){
        require(msg.sender==manager);//only manager will get the balance
        return address(this).balance; // balance of contract
    }

    function random() public view returns (uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,participant.length)));
    }

    function selectWinner() public {
        require (msg.sender==manager);
        require(participant.length>=3);
        address payable winner;
        uint index = ((random())%participant.length )   ;                          
        winner = participant[index];
        winner.transfer(getBalance());
        //----> REseting the array
        participant=new address payable[](0);
    }

}
