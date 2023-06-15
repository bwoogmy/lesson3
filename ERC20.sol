//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;


contract ERC20 {


   string public _name;
   string public _symbol;
   uint public _totalSupply;
   address public owner;

   mapping(address => uint) public balances;
   mapping(address => mapping(address => uint)) public allowens;
   mapping(address => bool) public Minters;
  constructor(string memory tokenName, string memory tokenSymbol, uint tokenTotalSupply) {
      _name = tokenName;
      _symbol = tokenSymbol;
      _totalSupply = tokenTotalSupply;
      balances[msg.sender] = tokenTotalSupply;
      owner = msg.sender;
  }

  function setMinter(address _address) public {
    require(msg.sender == owner,'only owner');
    Minters[_address] = true;
  }
  function name() public view returns(string memory) {
    return _name;
  }
  function symbol() public view returns(string memory){
    return _symbol;
  }
  function totalSupply() public view returns (uint){
    return _totalSupply;
  }
  
  function balanceOf(address _address) public view returns(uint){
    return balances[_address];
  }
  
  function tranfer (address _to, uint _amount) public returns (bool){
    balances[msg.sender]=balances[msg.sender] - _amount;
    balances[_to] = balances[_to] + _amount;
    return true;
  }


  function approve(address _sender, uint _amount) public  {
    allowens[msg.sender][_sender] = _amount;
  }

  function transferFrom(address _from, address _to, uint _amount) public {
    require(allowens[_from][_to] >= _amount,'not enough amount');
    balances[_from] = balances[_from] - _amount;
    balances[_to] += _amount;
    allowens[_from][_to] -= _amount;
  }

  function mint(address _to, uint _amount) public {
    require(Minters[msg.sender] == true, 'Only minter can do it');
    //balances[_to] = balances[_to] + _amount;
    uint i = 1;
    i = i + 1;
    i++;
    //_totalSupply = _totalSupply + _amount;
    _totalSupply += _amount;
    balances[_to] += _amount;
  }


}  
  //function blanceOf(address _address) public view returns(address)

  // 1function name() public view returns(string memory)

  //2 function symbol() public view returns(string memory)

  // function transfer(address _to, uint amout) public returns(bool)

  // function transferFrom(address _from, address _to, uint _amount) public 

  // function approve(address _sender, uint amount)


  //lesson2 hardhat 
  // inside folder hardhat in console run:    npm i

  // write function and test for this functions




