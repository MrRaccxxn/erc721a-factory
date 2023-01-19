// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "erc721a/contracts/ERC721A.sol";

contract Event is ERC721A, ReentrancyGuard {
    address owner;
    uint256 ticketsCounter;
    event newTicketMinted(
        uint256 fromTicket,
        uint256 quantity,
        address ticketOwner
    );

    constructor(
        string memory eventName,
        string memory symbol,
        address _owner
    ) ERC721A(eventName, symbol) {
        owner = _owner;
        ticketsCounter = 0;
    }

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is another contract");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function mint(uint256 quantity, address ticketOwner)
        external
        payable
        callerIsUser
        nonReentrant
    {
        require(quantity > 0, "Quantity should be more than zero");
        _safeMint(ticketOwner, quantity);
        ticketsCounter += quantity;
        emit newTicketMinted({
            fromTicket: ticketsCounter,
            quantity: quantity,
            ticketOwner: ticketOwner
        });
    }
}
