pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {InfernalRiftAbove} from "../src/InfernalRiftAbove.sol";
import {IInfernalRiftAbove} from "../src/interfaces/IInfernalRiftAbove.sol";

contract EncodeTest is Test {
    function test_getEncoded() external {
        address _INFERNAL_RIFT_ABOVE = 0x14a85AE3ED5FF92635c30003352A0305D301AF40; // Mainnet Sepolia

        address _RECIPIENT = 0xb06a64615842CbA9b3Bdb7e6F726F3a5BD20daC2;

        address[] memory collectionAddresses = new address[](1);
        collectionAddresses[0] = 0x3d7E741B5E806303ADbE0706c827d3AcF0696516;

        uint[][] memory idsToCross = new uint[][](1);
        idsToCross[0] = new uint[](3);
        idsToCross[0][0] = 375;
        idsToCross[0][1] = 376;
        idsToCross[0][2] = 377;

        uint[][] memory amountsToCross = new uint[][](1);
        amountsToCross[0] = new uint[](3);

        bytes memory callData = abi.encodeCall(
            InfernalRiftAbove.crossTheThreshold,
            (
                IInfernalRiftAbove.ThresholdCrossParams({
                    collectionAddresses: collectionAddresses,
                    idsToCross: idsToCross,
                    amountsToCross: amountsToCross,
                    recipient: _RECIPIENT,
                    gasLimit: 45_000 wei
                })
            )
        );

        console.logBytes(callData);
    }
}
