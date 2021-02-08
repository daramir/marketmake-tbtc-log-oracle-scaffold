/** This example code is designed to quickly deploy an example contract using Remix.
 *  If you have never used Remix, try our example walkthrough: https://docs.chain.link/docs/example-walkthrough
 *  You will need testnet ETH and LINK.
 *     - Kovan ETH faucet: https://faucet.kovan.network/
 *     - Kovan LINK faucet: https://kovan.chain.link/
 */

pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";
import "./BrokerSystem.sol";

contract APIConsumer is ChainlinkClient {
      
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    BrokerSystem public receiver;
    address owner;
    
    /**
     * Network: Kovan
     * https://market.link/jobs/6ae392e5-0a87-4779-962c-47de549f92f1
     * Chainlink - 0x6A7438e208fA022C4C8a71BF1e4aa2D59EDf6a2c
     * Chainlink - 928eb3dd3660460d8b681c8d0c633a55
     * Fee: 0.08 LINK
     */
    constructor(address brokerReceiver) public {
        setPublicChainlinkToken();
        oracle = 0x6A7438e208fA022C4C8a71BF1e4aa2D59EDf6a2c;
        jobId = "928eb3dd3660460d8b681c8d0c633a55";
        fee = 0.08 * 10 ** 18; // 0.01 LINK
        receiver = BrokerSystem(brokerReceiver);
    }
    
    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000000000000000000 (to remove decimal places from data).
     */
    function requestVolumeData() public returns (bytes32 requestId) 
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
        // Set the URL to perform the GET request on
        request.add("get", "https://api.etherscan.io/api?module=logs&action=getLogs&fromBlock=379224&toBlock=latest&address=0x33990122638b9132ca29c723bdf037f1a891a70c&topic0=0xf63780e752c6a54a94fc52715dbc5518a3b4c3c2833d301a204226548a2a8545&apikey=YourApiKeyToken");
        
        // Set the path to find the desired data in the API response, where the response format is:
        request.add("path", "result.0.address");
        
        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }
    
    /**
     * Receive the response in the form of bytes32
     */ 
    function fulfill(bytes32 _requestId, bytes32 response) public recordChainlinkFulfillment(_requestId)
    {
        receiver.receiveOracleFulfill(address(uint160(bytes20(response))));
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    
    /**
     * Withdraw LINK from this contract
     * 
     * NOTE: DO NOT USE THIS IN PRODUCTION AS IT CAN BE CALLED BY ANY ADDRESS.
     * THIS IS PURELY FOR EXAMPLE PURPOSES ONLY.
     */
    function withdrawLink() external onlyOwner{
        LinkTokenInterface linkToken = LinkTokenInterface(chainlinkTokenAddress());
        require(linkToken.transfer(msg.sender, linkToken.balanceOf(address(this))), "Unable to transfer");
    }
}