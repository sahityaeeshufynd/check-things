// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

/**
- Contract uses a single URI which is the monion IPFS URI for hosting metadata
- Contract relies on the metadata to store relevant info about the token such as name, description etc.
- Contract issues tokenId to each token minted
- Contract use is cheaper than if the user deployed a fresh instance of the ERC1155

*/

contract UserDefined1155 is ERC1155, Ownable, Pausable, ERC2981, ERC1155Supply {
    event Minted(
        uint indexed tokenId,
        address indexed owner,
        address indexed nftAddress,
        uint quantity
    );

    address operator;
    uint tokenCounter = 0;
    address nft_address = 0x000000000000000000000000000000000000dEaD;
    string name;
    string symbol;

    constructor(
        address _operator,
        string memory _name,
        string memory _symbol
    ) ERC1155("abc-/{id}.json") {
        operator = _operator;
        name = _name;
        symbol = _symbol;
        //string storage _name, string storage _symbol
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(
        address account,
        uint quantity,
        string memory newuri,
        uint96 royaltyFee
    ) public {
        tokenCounter++;
        uint tokenId = tokenCounter;
        _mint(account, tokenId, quantity, "");
        _setURI(newuri);
        setApprovalForAll(operator, true);
        _setDefaultRoyalty(account, royaltyFee);
        nft_address = address(this);
        //Should I generate a hex code using the tokenId, so that the hex code is used to create a link?
        emit Minted(tokenId, account, address(this), quantity);
    }

    function limited_mint(
        address account,
        uint quantity,
        string memory newuri,
        uint96 royaltyFee,
        uint96 limit
    ) public {
        tokenCounter++;
        require(tokenCounter <= limit, "no more NFTs can be minted");
        uint tokenId = tokenCounter;
        _mint(account, tokenId, quantity, "");
        _setURI(newuri);
        setApprovalForAll(operator, true);
        _setDefaultRoyalty(account, royaltyFee);
        nft_address = address(this);
        //Should I generate a hex code using the tokenId, so that the hex code is used to create a link?
        emit Minted(tokenId, account, address(this), quantity);
    }

    function NFT_address() public view onlyOwner returns (address) {
        require(
            nft_address != 0x000000000000000000000000000000000000dEaD,
            "No Nfts are minted"
        );
        return nft_address;
    }

    function getTokenCount() public view onlyOwner returns (uint) {
        return tokenCounter;
    }

    function _beforeTokenTransfer(
        address theOperator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) whenNotPaused {
        super._beforeTokenTransfer(theOperator, from, to, ids, amounts, data);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC1155, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
