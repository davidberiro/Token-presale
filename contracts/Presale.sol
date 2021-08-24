//SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "./BEP20.sol";

contract Presale is BEP20('Revault.network presale token', 'REVAPT') {
    using SafeMath for uint;

    uint maxBNBPerAddress;
    uint tokenPerBNB;
    uint BNBCap;

    uint totalBNBReceived = 0;
    bool isActive = false;

    mapping (address => bool) public isWhitelisted;
    mapping (address => uint) public totalBNBSent;

    constructor(uint _maxBNBPerAddress, uint _tokenPerBNB, uint _BNBCap) public {
        maxBNBPerAddress = _maxBNBPerAddress;
        tokenPerBNB = _tokenPerBNB;
        BNBCap = _BNBCap;
    }

    function setWhitelist(address _user) public onlyOwner {
        isWhitelisted[_user] = true;
    }

    function setWhitelists(address[] memory _users) public onlyOwner {
        for (uint i = 0; i < _users.length; i++) {
            isWhitelisted[_users[i]] = true;
        }
    }

    function setActive(bool _active) public onlyOwner {
        isActive = _active;
    }

    function sendBNB(address _receiver, uint _value) public onlyOwner {
        payable(_receiver).transfer(_value);
    }

	receive() external payable {
        require(isActive, "Presale not active");
		require(isWhitelisted[msg.sender], "Sender not whitelisted");
        require(totalBNBSent[msg.sender].add(msg.value) <= maxBNBPerAddress, "Maximum BNB user limit reached");
        require(totalBNBReceived.add(msg.value) <= BNBCap, "Maximum BNB cap reached");
        totalBNBSent[msg.sender] = totalBNBSent[msg.sender].add(msg.value);
        BNBCap = BNBCap.add(msg.value);
        uint amount = (msg.value).mul(tokenPerBNB).div(1e18);
        _mint(msg.sender, amount);
	}

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(false, "Cannot transfer");
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        require(false, "Cannot transfer from");
    }
}
