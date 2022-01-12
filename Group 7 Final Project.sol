pragma solidity >=0.4.25 <0.8.0;

contract CrowdFundingCampaignFactory {

    address[] public deployedCampaigns; // an address array of the deployed campaign.

// the following function is created to create the campaign.
    function createCampaign(uint minimum) public  {
        address newCampaign = new CrowdfundingCampaign(minimum, msg.sender); // "msg.sender" will be the owner.
        deployedCampaigns.push(newCampaign); // pushing the campaign to the campaigns array. 
    }
// the following function is created to get a list of the deployed campaigns.
    function getDeplyedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }
}


contract CrowdfundingCampaign {
// the following struct is for a withdrawal request.
    struct Withdrawal{
            string description; // a descreption for why the withdrawl needs to be made. 
            uint value; // the value of the withdrawal.
            address recipient; // in case the owner of the contract want to send the withdrawal to someone other than himself.
            bool complete; // to mark wether the withdrawl is completed or not.
            uint approvalCount; // to make sure we have the exact number of approvals (in this contract it will be more than 50% of the contributors).
            mapping(address => bool) approvals; // to make sure if someone has already approved he will not be able to approve again.

    }      

    Withdrawal[] public withdrawals; 
    address public owner; // adreess for whoever starts the contract
    mapping (address => bool) contributors; // to keep track of all the contributors. we will have their adressess then check if they contributed or not.
    uint public contributorsCount; // number of contributors. Every time there is a contibutor it will add to contributorsCount. 
    uint public minimumContribution; // minimum amount of the contribution. so when you contibute to a campaign you have to at least send in a specified amount.


    constructor(uint minimum, address creator) public {
        owner = creator;
        minimumContribution = minimum; 
    }
// the follwing function is created to allow people to contribute some amount of Eth to the campaign.
    function contibute() public payable { 
        require(msg.value>= minimumContribution); // to make sure that every amount people sent is greater than or equal to the minmum amount of the contribution. 
        contributors[msg.sender]=true; // to add the contributors addresses.
        contributorsCount++; // to increase the contributors count.


    }
// the following modifier is created to make sure that only the owener can call some functions.
    modifier onlyOwner() {
        require(msg.sender == owner);
        
         _;

        }
// the following modifier is created to check if the contributors are in their addresses.
    modifier onlyContributer() {
        require(contributors[msg.sender]);
        _;

        }
// the following function is created to be called by only the OWNER, the owenr will need the discription of the withdrawal, the value of the withdrawal and the recipient address.
    function creatWithdrawal(string memory description, uint value, address recipient) public onlyOwner {
        Withdrawal memory newWithdrawal = Withdrawal ({
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            approvalCount:0
        });
        withdrawals.push(newWithdrawal); // setting up an array to add the new withdrawals.
    }
 // the following function is created to grab the actual withdrawal request.  
    function approveWithdrawal(uint index) public onlyContributer {
        Withdrawal storage withdrawal = withdrawals[index]; // each withdrawal request will have an index that helps to locate the request.
        require(!withdrawal.approvals[msg.sender]); // to make sure that whoever sending the approval hasn't already approved it.
        withdrawal.approvals[msg.sender]==true;
        withdrawal.approvalCount++; // increasing the approval count when "true".
        
    }
// the following function is created to transfer and draw the fund.    
     function finalizeWithdrawal(uint index) public onlyOwner { 
         Withdrawal storage withdrawal = withdrawals[index];
         require(withdrawal.approvalCount >= (contributorsCount / 2 )); // we want to require that the approval count is more than or equal to 50% of the approvals.
         require(!withdrawal.complete); // to make sure the withdrawal hasn't completed before.

         withdrawal.recipient.transfer(withdrawal.value); // sending the withdrawal to the recipient.
         withdrawal.complete = true;

     }

}
