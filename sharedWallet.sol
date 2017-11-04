pragma solidity ^0.4.16;

contract Owner {
    address owner;
    
    modifier walletAdmin() {
        if(msg.sender != owner) throw;
        
        _;
    }
    
    function Owner() {
        owner = msg.sender;
    }
}

contract Mortal is Owner {
    function kill() {
        if(msg.sender == owner)
            selfdestruct(owner);
    }
}

contract MyWallet is Mortal {
    // if this contract recieves any money fire a message of how much was sent
    event recievedEther(address indexed _from, uint256 _amount);
    event proposalRecieved(address indexed _to, address indexed _from, string _reason);
    
    struct Proposal {
        address _to;
        address _from;
        uint256 _amount;
        string _reason;
        bool sent;
    }
    
    uint proposalCounter;
    
    mapping(uint => Proposal) m_proposals;
    
    function spendEther(address _to, uint256 _amount, string _reason) returns (uint256) {
        if(msg.sender == owner) {
            bool sent = _to.send(_amount);
            if(!sent){
                throw;
            }
        }
        else {
            proposalCounter++;
            m_proposals[proposalCounter] = Proposal(_to, msg.sender, _amount, _reason, false);
            proposalRecieved(_to, msg.sender, _reason);
            return proposalCounter;
        }
        
    }
    
    function proposalConfirm(uint proposal_id) walletAdmin returns(bool) {
        Proposal proposal = m_proposals[proposal_id];
        // this is checking to see if the proposal was, in fact, set
        if(proposal._from != address(0)){
            if(proposal.sent != true){
                proposal.sent = true;
                if(proposal._to.send(proposal._amount)){
                    return true;
                }
                proposal.sent = false;
                return false;
            }
        }
    }
    
    function () payable {
        if(msg.value > 0) {
            recievedEther(msg.sender, msg.value);
        }
        
    }
}
