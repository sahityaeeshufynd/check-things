// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./NFTStorage.sol";
import "./UserDefined1155.sol";
import "./KraftNFT.sol";
import "hardhat/console.sol";

// import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract Listing {
    event ListedForSale(
        uint indexed tokenId,
        address indexed nftAddress,
        uint tokenPrice,
        address indexed listedBy,
        uint quantity
    );
    event RemovedNFT(
        uint indexed tokenId,
        address indexed nftAddress,
        address indexed removedBy
    );
    event DecreasedNFTUnits(
        uint indexed tokenId,
        address indexed nftAddress,
        address indexed removedBy,
        uint quantity
    );
    event UpdatedPrice(
        uint indexed tokenId,
        address indexed nftAddress,
        address indexed owner,
        uint newPrice
    );

    MyNFTStorage vault;
    KraftNFT kraftMinter;

    mapping(address => address[]) private userToUserDefinedNFTs;

    constructor(address _storageAddress, address _kraftnft) {
        vault = MyNFTStorage(_storageAddress);
        kraftMinter = KraftNFT(_kraftnft);
    }

    function mintKraftNFT(
        uint quantity,
        uint96 royaltyFee,
        string memory newuri
    ) external {
        kraftMinter.mint(quantity, msg.sender, newuri, royaltyFee);
    }

    // function mintUserNFT(uint amount, uint96 _fee) external {
    //     UserDefined1155 userMinter = new UserDefined1155(amount, address(vault), _fee);
    //     userMinter.mint(msg.sender);
    //     console.log("The address for the minted NFT is: ", address(userMinter));
    //     // userToUserDefinedNFTs[msg.sender].push(address(userMinter));
    // }

    function addUserDefinedListingForSale(
        address nftAddress,
        uint tokenId,
        uint tokenPrice,
        uint quantity
    ) external {
        vault._listUserDefinedNFTForSale(
            nftAddress,
            tokenId,
            tokenPrice,
            payable(msg.sender),
            quantity
        );
        uint price = vault.getTokenPrice(nftAddress, tokenId, msg.sender);
        emit ListedForSale(tokenId, nftAddress, price, msg.sender, quantity);
    }

    function addKraftListingForSale(
        address nftAddress,
        uint tokenId,
        uint tokenPrice,
        uint quantity
    ) external {
        vault._listKraftNFTForSale(
            nftAddress,
            tokenId,
            tokenPrice,
            payable(msg.sender),
            quantity
        );
        uint price = vault.getTokenPrice(nftAddress, tokenId, msg.sender);
        emit ListedForSale(tokenId, nftAddress, price, msg.sender, quantity);
    }

    function updatePrice(
        address nftAddress,
        uint tokenId,
        uint price
    ) external {
        vault._updateTokenPrice(nftAddress, tokenId, msg.sender, price);
        emit UpdatedPrice(tokenId, nftAddress, msg.sender, price);
    }

    function removeNFT(address nftAddress, uint tokenId) public {
        vault._delistNFT(nftAddress, tokenId, msg.sender);
        // uint length = userToUserDefinedNFTs[msg.sender].length;
        // for(uint i = 0; i < length; i++){
        //     if(nftAddress == userToUserDefinedNFTs[msg.sender][i]){
        //         userToUserDefinedNFTs[msg.sender][i] = userToUserDefinedNFTs[msg.sender][length - 1];
        //         userToUserDefinedNFTs[msg.sender].pop();
        //     }
        // }
        emit RemovedNFT(tokenId, nftAddress, msg.sender);
    }

    function decreaseUnits(
        address nftAddress,
        uint tokenId,
        uint quantity
    ) public {
        vault._reduceNFTUnits(nftAddress, tokenId, msg.sender, quantity);
        emit DecreasedNFTUnits(tokenId, nftAddress, msg.sender, quantity);
    }
}
