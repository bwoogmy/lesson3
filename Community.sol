//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import './ERC20.sol';

// import "hardhat/console.sol";


contract Community {
 
    string public CommunityName;
    address public usdtAddress;
    address public owner;

    

    uint matchId;

    struct Match {
        string name;
        string part1;
        string part2;
        uint scorePart1;
        uint scorePart2;
        uint startDate;
        uint minBet;
        uint resultApprove;
        uint totalBetAmountPart1;
        uint totalBetAmountPart2;
    }


    struct User {
        uint balance;
        bool active;
        bool signed;
    }

    struct Bet {
        uint amount;
        uint bet;
    }

    //      matchId         userAddress  amount
    mapping(uint => mapping(address => Bet)) public UsersBetsByMatchId;
    mapping(address => bool) public Validators;
    mapping(uint => Match) public Matches;
    mapping(address => User) public Users;

    constructor(address _usdt) {
        usdtAddress = _usdt;
        owner = msg.sender;
    }

    function addValidator(address _validator) public {
        require(owner == msg.sender, 'only owner');
        Validators[_validator] = true;
    }
    
    function getMatch(uint _id) public view returns(Match memory) {
        return Matches[_id];
    }

    function addMatch(string memory _name, 
                      string memory _part1, 
                      string memory _part2, 
                      uint _startDate,
                      uint _minBet) public {
        matchId += 1;
        Matches[matchId].name = _name;
        Matches[matchId].part1 = _part1;
        Matches[matchId].part2 = _part2;
        Matches[matchId].startDate = _startDate;
        Matches[matchId].minBet = _minBet;

    }

    function signIn() public {
         Users[msg.sender].signed = true;
         Users[msg.sender].active = true;
    }


    // bet if 1 part1 will win and 2 part2 wil win
    function makeBet(uint _match_id, uint _amount, uint _bet) public {
       // require(Matches[_match_id].startDate > block.timestamp, 'Only befor event');
        require(_amount >= Matches[_match_id].minBet, 'minimal ber');
        ERC20 _usdt = ERC20(usdtAddress);
        _usdt.transferFrom(msg.sender, address(this), _amount);
        Users[msg.sender].balance = _amount;
        UsersBetsByMatchId[_match_id][msg.sender].amount = _amount;
        UsersBetsByMatchId[_match_id][msg.sender].bet = _bet;
        if (_bet == 1) {
            Matches[_match_id].totalBetAmountPart1 += _amount;
        } 
        if (_bet == 2) {
            Matches[_match_id].totalBetAmountPart2 += _amount;
        }
        
    }

    function Validate(uint _match_id) public {
        require(Validators[msg.sender] == true,'only validator can call');
        Matches[_match_id].resultApprove += 1;
    }


    function calculateBetResult(uint _amount_lose, uint _amount_win, uint _winner) public pure returns(uint _win) {
                uint _per_usdt = _amount_lose * 10e18 / (_amount_win);
                _win = (_per_usdt * _winner)/10e18;
    } 

    function claimResult(uint _match_id) public returns(bool) {
        require(Matches[_match_id].resultApprove > 0,'is not approved');
        uint _current_bet;
        uint _amount_lost;
        uint _amount_win;
        if (Matches[_match_id].scorePart1 > Matches[_match_id].scorePart2) {
         _current_bet == 1;
        } else {
            _current_bet == 2;
        }
        if (UsersBetsByMatchId[_match_id][msg.sender].bet != _current_bet) {
            return false;
        }
        if (_current_bet == 1) {
           _amount_lost = Matches[_match_id].totalBetAmountPart2;
           _amount_win = Matches[_match_id].totalBetAmountPart1;
        } else {
            _amount_lost = Matches[_match_id].totalBetAmountPart1;
            _amount_win = Matches[_match_id].totalBetAmountPart2;
        }
        uint _bet = UsersBetsByMatchId[_match_id][msg.sender].amount;
        uint _resultUSDT = calculateBetResult(_amount_lost, _amount_win, _bet);
        ERC20(usdtAddress).tranfer(msg.sender, _resultUSDT);
        return true;
    }

     
}