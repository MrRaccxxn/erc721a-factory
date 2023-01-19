// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import {Event} from "./Event.sol";

contract EventFactory is Ownable {
    uint256 eventsCounter;

    constructor() {
        eventsCounter = 0;
    }

    mapping(uint256 => eventInfo) events;

    struct eventInfo {
        uint256 eventId;
        address owner;
        string eventName;
        address eventAddress;
    }

    event newEventCreated(
        uint256 eventId,
        address owner,
        string eventName,
        address eventAddress
    );

    function createNewEvent(
        string memory eventName,
        string memory eventSymbol,
        address eventOwner
    ) public onlyOwner returns (address) {
        address eventAddress = address(
            new Event(eventName, eventSymbol, eventOwner)
        );
        eventInfo storage _eventInfo = events[eventsCounter];
        _eventInfo.eventId = eventsCounter;
        _eventInfo.owner = eventOwner;
        _eventInfo.eventName = eventName;
        _eventInfo.eventAddress = eventAddress;

        emit newEventCreated(
            eventsCounter,
            eventOwner,
            eventName,
            eventAddress
        );
        eventsCounter++;

        return eventAddress;
    }

    function getEventById(uint256 eventId)
        public
        view
        returns (
            uint256,
            address,
            string memory,
            address
        )
    {
        require(
            eventId >= 0 && eventId < eventsCounter,
            "Please submit a valid Event Id"
        );
        eventInfo storage _eventInfo = events[eventId];
        return (
            _eventInfo.eventId,
            _eventInfo.owner,
            _eventInfo.eventName,
            _eventInfo.eventAddress
        );
    }
}
