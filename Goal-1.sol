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
