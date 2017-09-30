pragma solidity ^0.4.9;

/* This greeter shows some basic functionality of a smart contract
that takes whatever string set and then returns that string when you
call its getGreeting() function
*/

contract MyGreeter {
    
    string greeting;
    address deployer;
    
    /// This is a basic constructor of the Greeter contract and works much like a class
    function MyGreeter (string _greeting) {
        deployer = msg.sender; // We need the contract deployer to be the person who created it
        greeting = _greeting; // We need a string for the greeting to be set when contract is constructed
    }
    
    /// Change the _greeting whenever you call this
    function setGreeting (string _newGreeting) {
        greeting = _newGreeting;
    }
    
    /// Get the greeting. (Since it is read only, use the constant keyword to avoid using gas)
    function getGreeting () constant  returns (string){
        return greeting;
    }
    
    /// This function kills the contract instance and returns whatever balance is there to the deployer
    function kill () {
        if (msg.sender != deployer)
            throw;
        suicide(deployer); // This is useful when you are finished with a contract, because it costs 
                           // far less gas than just sending the balance with address.send(this.balance)
    }
}
