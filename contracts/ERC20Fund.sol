pragma solidity ^0.6.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';


contract SimpleERCFund {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    uint256 public allowAmount;
    address public owner;
    address payable public recAddr;
    address public forkToken;

    constructor(address _fork) public {
        forkToken = _fork;
        owner = msg.sender;
    }

    function withdraw(
        address token,
        uint256 amount
    ) public {
        if (token == forkToken) {
            allowAmount = allowAmount.sub(amount);
            IERC20(token).safeTransfer(recAddr, amount);
        } else {
            IERC20(token).safeTransfer(recAddr, amount);
        }
        if (address(this).balance > 0) {
            recAddr.transfer(address(this).balance);
        }
    }

    function addAllowAmount(uint256 amount) public {
        require(msg.sender == owner, "on owner");
        allowAmount = allowAmount.add(amount);
    }

    function setOwner(address _newOwner) public {
        require(msg.sender == owner, "no owner");
        owner = _newOwner;
    }

    function setRecAddr(address payable _addr) public {
        require(msg.sender == recAddr, "on receiver");
        recAddr = _addr;
    }

    
}
