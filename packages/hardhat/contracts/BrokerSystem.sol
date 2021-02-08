// SPDX-License-Identifier: MIT
pragma solidity ^0.6.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";

contract BrokerSystem {
    IERC20 listener;
    ChainlinkClient oracle;
    address owner;

    // Mapping from address to uint
    mapping(address => uint256) public redeemMap;

    modifier onlyOracle {
        require(msg.sender == address(oracle));
        _;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor(address watchedContract) public {
        owner = msg.sender;
        listener = IERC20(watchedContract);
    }

    function setOracle(address whitelistedOracle) external onlyOwner {
        oracle = ChainlinkClient(whitelistedOracle);
    }

    /**
     * Receive the response in the form of bytes32
     */

    function receiveOracleFulfill(address emitter) public onlyOracle {
        redeemMap[emitter]++;
    }
}
