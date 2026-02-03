// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ToyHash {
    function subblock(bytes memory data, uint8 prevLastBit) internal pure returns (bytes memory, uint8) {
        require(data.length == 7, "subblock: input must be exactly 7 bytes");

        uint8 firstByte = uint8(data[0]);
        uint8 currFirstBit = (firstByte >> 7) & 0x01;

        uint8 xorBit = prevLastBit ^ currFirstBit;

        bytes memory modified = new bytes(7);
        modified[0] = bytes1(firstByte & 0x7F | (xorBit << 7));
        for (uint256 i = 1; i < 7; i++) {
            modified[i] = data[i];
        }

        bytes32 digest = keccak256(modified);
        bytes memory out = new bytes(3);
        for (uint256 i = 0; i < 3; i++) {
            out[i] = digest[i];
        }

        uint8 lastByte = uint8(data[6]);
        uint8 lastBit = lastByte & 0x01;

        return (out, lastBit);
    }

    function blockHash(bytes memory data) internal pure returns (bytes memory) {
        require(data.length == 28, "blockHash: must be exactly 28 bytes");

        bytes memory out = new bytes(0);
        bytes[4] memory subs;

        for (uint256 i = 0; i < 4; i++) {
            bytes memory sub = new bytes(7);
            for (uint256 j = 0; j < 7; j++) {
                sub[j] = data[i * 7 + j];
            }
            subs[i] = sub;
        }

        uint8 lastByte = uint8(subs[3][6]);
        uint8 prevLastBit = lastByte & 0x01;

        for (uint256 i = 0; i < 4; i++) {
            (bytes memory partial2, uint8 lastBit) = subblock(subs[i], prevLastBit);
            prevLastBit = lastBit;
            out = bytes.concat(out, partial2);
        }

        return out;
    }

    function hash(bytes memory data) public pure returns (bytes memory) {
        uint256 paddedLen = 0;
        if (data.length % 28 != 0){
            paddedLen = 28-(data.length%28);
        }
        bytes memory padded = new bytes(data.length + paddedLen);
        for (uint256 i = 0; i < data.length; i++) {
            padded[i] = data[i];
        }
        for (uint256 i=0;i<paddedLen;i++){
            padded[data.length+i]=bytes1(0);
        }

        bytes memory h;
        for (uint256 i = 0; i < padded.length; i += 28) {
            bytes memory blockData = new bytes(28);
            for (uint256 j = 0; j < 28; j++) {
                blockData[j] = padded[i + j];
            }
            bytes memory bh = blockHash(blockData);
            h = bytes.concat(h, bh);
        }

        bytes32 digest = keccak256(h);
        bytes memory out = new bytes(16);
        for (uint256 i = 0; i < 16; i++) {
            out[i] = digest[i];
        }
        return out;
    }
}


contract ToyMixer {
    struct DepositInfo {
        uint256 amount;
        bool withdrawn;
    }

    mapping(bytes => DepositInfo) public deposits;

    function deposit(bytes memory hashValue) external payable {
        require(msg.value > 0, "Deposit amount must be > 0");
        require(deposits[hashValue].amount == 0, "Already deposited");

        deposits[hashValue] = DepositInfo({
            amount: msg.value,
            withdrawn: false
        });
    }

    function withdraw(address payable receiver, bytes8 salt, uint64 ethAmount) external {
        ToyHash hasher = new ToyHash();
        bytes memory packed = abi.encodePacked(salt, receiver, ethAmount);
        bytes memory hashValue = hasher.hash(packed);

        DepositInfo storage info = deposits[hashValue];
        require(info.amount == uint256(ethAmount), "Amount mismatch");
        require(!info.withdrawn, "Already withdrawn");
        require(info.amount > 0, "No deposit found");

        info.withdrawn = true;
        (bool sent, ) = receiver.call{value: info.amount}("");
        require(sent, "ETH transfer failed");
        delete deposits[hashValue];
    }
}
