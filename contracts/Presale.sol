//SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/BEP20.sol";
import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";

contract Presale is BEP20('PRESALE', 'PRESALE') {
    using SafeMath for uint;

    uint maxBNBPerAddress;
    uint tokenPerBNB;

    bool isActive;

    mapping (address => bool) public isWhitelisted;
    mapping (address => uint) public totalBNBSent;

    constructor(uint _maxBNBPerAddress, uint _tokenPerBNB) public {
        maxBNBPerAddress = _maxBNBPerAddress;
        tokenPerBNB = _tokenPerBNB;
    }

    function setWhitelist(address _user) public onlyOwner {
        isWhitelisted[_user] = true;
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
        require(totalBNBSent[msg.sender].add(msg.value) <= maxBNBPerAddress, "Maximum BNB limit reached");
        totalBNBSent[msg.sender] = totalBNBSent[msg.sender].add(msg.value);
        uint amount = (msg.value).mul(tokenPerBNB).div(1e18);
        _mint(msg.sender, amount);
	}
}
