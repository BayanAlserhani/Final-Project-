contract CrowdFunding {
// the following struct is for a withdrawal request.
    
    mapping(address => bool) approvals; // to make sure if someone has already approved he will not be able to approve again.
    withdrawal[] public withdrawals; 
    address public owner; // adreess for whoever starts the contract
    mapping (address => bool) contributors; // to keep track of all the contributors. we will have their adressess then chech if they contributed or not.
    uint public contributorsCount; // number of contributors. Every time there is a contibutor it will add to contributorsCount. 
    uint public minimumContribution; // minimum amount of the contribution. so when you contibute to a campaign you have to at least send in a specified amount.
    uint public deadline; 
    uint public goal;
    uint public raisedAmount;

}
    
