// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";

import {IERC1155} from "@openzeppelin/token/ERC1155/IERC1155.sol";

import {InfernalRiftAbove} from "../src/InfernalRiftAbove.sol";
import {IInfernalRiftAbove} from "../src/interfaces/IInfernalRiftAbove.sol";

interface Mock1155 {
    function mint(uint256 amount) external returns (uint256 tokenId);

    function mint(uint256 tokenId, uint256 amount) external;
}

/**
 * Configures Above with information about Below.
 *
 * Sepolia: `forge script script/Bridge1155.s.sol:Bridge1155 --rpc-url "https://eth-sepolia.g.alchemy.com/v2/_RDgKRq2wGVTLXJ98vHHDfjr_dfQzTkS" --broadcast -vvvv --legacy`
 */
contract Bridge1155 is Script {
    function run() external {
        vm.startBroadcast(vm.envUint("DEV_PRIVATE_KEY"));

        address _INFERNAL_RIFT_ABOVE = 0x329d63f8850fA73E9D74443f091A8E2458521245; // Mainnet Sepolia

        address _RECIPIENT = 0xb06a64615842CbA9b3Bdb7e6F726F3a5BD20daC2;

        address[] memory collectionAddresses = new address[](1);
        collectionAddresses[0] = 0x2369dff13b5F2778Fe90e5cdE5d40CCF7b72135e;

        // mint 3 nfts
        uint256 tokenId = 1;
        Mock1155(collectionAddresses[0]).mint(tokenId, 3);

        uint[][] memory idsToCross = new uint[][](1);
        idsToCross[0] = new uint[](1);
        idsToCross[0][0] = tokenId;

        uint[][] memory amountsToCross = new uint[][](1);
        amountsToCross[0] = new uint[](1);
        amountsToCross[0][0] = 3;

        IERC1155(collectionAddresses[0]).setApprovalForAll(
            _INFERNAL_RIFT_ABOVE,
            true
        );

        InfernalRiftAbove(_INFERNAL_RIFT_ABOVE).crossTheThreshold1155{
            value: 0 ether
        }(
            IInfernalRiftAbove.ThresholdCrossParams({
                collectionAddresses: collectionAddresses,
                idsToCross: idsToCross,
                amountsToCross: amountsToCross,
                recipient: _RECIPIENT,
                gasLimit: 2_000_000 wei
            })
        );

        IERC1155(collectionAddresses[0]).setApprovalForAll(
            _INFERNAL_RIFT_ABOVE,
            false
        );

        vm.stopBroadcast();
    }
}
